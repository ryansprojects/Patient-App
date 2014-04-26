//Bluetooth Global Parameters and Settings

public final String deviceName = "HC-06";   ///NAME of HEADSET BLUETOOTH MODULE !!!!IMPORTANT!!!!!

SendReceiveBytes sendReceiveBT;   //SendReceive data Object for Bluetooth; !!!!IMPORTANT!!!!!
                                  //has public function .wrtie(byte) to send byte via Bluetooth

//////////////////////////////////////
//Reading/Writing data over bluetooth
//////////////////////////////////////
int BTReceiveMode = 1;                                 //Mode of the Bluetooth receiver
                                                       // 1 = sampling mode (continous read of bytes)
int byteSetNum = 1;                                    //location of bytes being received (1st,2nd,3rd...etc. set of bytes)
String readMessage="";                                 //String to hold message being received (chars)
byte[] sendNextByte = stringToBytesUTFCustom("R");     //constant parameter to signal MCU to send next set of byte(s)
boolean writingDataBT = false;                         //signal when Bluetooth routing is writing data to file

////////////////////////////////////
//State of bluetooth Connection
///////////////////////////////////
boolean foundDevice=false; //When true, device have been found
boolean BTisConnected=false; //When true, device is connected


//Get the default Bluetooth adapter
BluetoothAdapter bluetooth = BluetoothAdapter.getDefaultAdapter();
/* Create a BroadcastReceiver that will later be used to 
 receive the names of Bluetooth devices in range. */
BroadcastReceiver myDiscoverer = new myOwnBroadcastReceiver();


/* Create a BroadcastReceiver that will later be used to
 identify if the Bluetooth device is connected */
BroadcastReceiver checkIsConnected = new myOwnBroadcastReceiver();



/* Most of the code in SendReceiveBytes was written by ScottC on 25 March 2013
 */

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.widget.Toast;
import android.view.Gravity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;

import java.util.UUID;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import android.bluetooth.BluetoothServerSocket;
import android.bluetooth.BluetoothSocket;
public BluetoothSocket scSocket;


// Message types used by the Handler
public static final int MESSAGE_WRITE = 1;
public static final int MESSAGE_READ = 2;


/*The startActivityForResult() within setup() launches an 
 Activity which is used to request the user to turn Bluetooth on. 
 The following onActivityResult() method is called when this 
 Activity exits. */
@Override
protected void onActivityResult(int requestCode, int resultCode, Intent data) {
 if (requestCode==0) {
 if (resultCode == RESULT_OK) {
 //text("Bluetooth has been switched ON",50,50);
 } 
 else {
 //text("You need to turn Bluetooth ON !!!",50,50);
 }
 }
}


// The Handler that gets information back from the Socket
private final Handler mHandler = new Handler() {
 @Override
 public void handleMessage(Message msg) {
 switch (msg.what) {
 case MESSAGE_WRITE:
 //Do something when writing
 break;
 case MESSAGE_READ:
 
 //Read Message from Bluetooth-------------------------------------------------
 
 //Get the set of bytes from the Handler Message msg.obj
 byte[] readBuf = (byte[]) msg.obj;
 // construct a string from the valid bytes in the buffer
 /*
 readMessage = new String(readBuf, 0, msg.arg1);
 
   if(byteSetNum == 1){ //first 16 bytes (1st set of bytes)
     
     writingDataBT = true;          //iniates a write procedure
     outputFile.print(readMessage);  //print to file but with no newline
     
     //Determine sample and euler angles
     sample = decodeFloat(readMessage.substring(0,8));
     roll = decodeFloat(readMessage.substring(8,16));
   
     byteSetNum = 2;          //next set will be second set
   }else{
   
     outputFile.println(readMessage); //print data but with newline(last set)
   
     //Determine sample and euler angles
     yaw = decodeFloat(readMessage.substring(0,8));
     pitch = decodeFloat(readMessage.substring(8,16));
   
     byteSetNum = 1;          //next set will be the first set
     writingDataBT = false;  //terminate write preocdure
   }
  
  //Tell MCU to send next set of bytes
  sendReceiveBT.write(sendNextByte);
  */
  //----------------------------------------------------------------------------
 
 break;
 }
 }
};


/* This BroadcastReceiver will display discovered Bluetooth devices */
public class myOwnBroadcastReceiver extends BroadcastReceiver {
 ConnectToBluetooth connectBT;

 @Override
 public void onReceive(Context context, Intent intent) {
 try {
 String action=intent.getAction();
 
 //text("ACTION:" + action,50,50);

 //Notification that BluetoothDevice is FOUND
 if (BluetoothDevice.ACTION_FOUND.equals(action)) {
 //Display the name of the discovered device
 String discoveredDeviceName = intent.getStringExtra(BluetoothDevice.EXTRA_NAME);
  //text("Discovered: " + discoveredDeviceName,50,50);

 //Display more information about the discovered device
 BluetoothDevice discoveredDevice = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
 //text("getAddress() = " + discoveredDevice.getAddress(),50,50);
 //text("getName() = " + discoveredDevice.getName(),50,50);

 int bondyState=discoveredDevice.getBondState();
 //text("getBondState() = " + bondyState,50,50);

 String mybondState;
 switch(bondyState) {
 case 10: 
 mybondState="BOND_NONE";
 break;
 case 11: 
 mybondState="BOND_BONDING";
 break;
 case 12: 
 mybondState="BOND_BONDED";
 break;
 default: 
 mybondState="INVALID BOND STATE";
 break;
 }
 //text("getBondState() = " + mybondState,50,50);

 //Change foundDevice to true which will make the screen turn green
 foundDevice=true;

 //Connect to the discovered bluetooth device
 if (discoveredDeviceName.equals(deviceName)) {
 //text("Connecting you Now !!",50,50);
 unregisterReceiver(myDiscoverer);
 connectBT = new ConnectToBluetooth(discoveredDevice);
 //Connect to the the device in a new thread
 new Thread(connectBT).start();
 }
 }

 //Notification if bluetooth device is connected
 if (BluetoothDevice.ACTION_ACL_CONNECTED.equals(action)) {
 //text("CONNECTED _ YAY",50,50);

 while (scSocket==null) {
 //do nothing
 }
 //text("scSocket" + scSocket,50,50);
 BTisConnected=true; //turn screen purple 
 if (scSocket!=null) {
 sendReceiveBT = new SendReceiveBytes(scSocket);
 new Thread(sendReceiveBT).start();
 
 /*
 String red = "r";
 byte[] myByte = stringToBytesUTFCustom(red);
 sendReceiveBT.write(myByte);
 */
 
 }
 }
 } catch (Exception e) {
   e.printStackTrace();
 }
 }
 
}

//Helpful function to translate a string to a set of representing bytes
public static byte[] stringToBytesUTFCustom(String str) {
 char[] buffer = str.toCharArray();
 byte[] b = new byte[buffer.length << 1];
 for (int i = 0; i < buffer.length; i++) {
 int bpos = i << 1;
 b[bpos] = (byte) ((buffer[i]&0xFF00)>>8);
 b[bpos + 1] = (byte) (buffer[i]&0x00FF);
 }
 return b;
}

public class ConnectToBluetooth implements Runnable {
 private BluetoothDevice btShield;
 private BluetoothSocket mySocket = null;
 private UUID uuid = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");

 public ConnectToBluetooth(BluetoothDevice bluetoothShield) {
 btShield = bluetoothShield;
 try {
 mySocket = btShield.createRfcommSocketToServiceRecord(uuid);
 }
 catch(IOException createSocketException) {
 //Problem with creating a socket
 Log.e("ConnectToBluetooth", "Error with Socket");
 }
 }

 @Override
 public void run() {
 /* Cancel discovery on Bluetooth Adapter to prevent slow connection */
 bluetooth.cancelDiscovery();

 try {
 /*Connect to the bluetoothShield through the Socket. This will block
 until it succeeds or throws an IOException */
 mySocket.connect();
 scSocket=mySocket;
 } 
 catch (IOException connectException) {
 Log.e("ConnectToBluetooth", "Error with Socket Connection");
 try {
 mySocket.close(); //try to close the socket
 }
 catch(IOException closeException) {
 }
 return;
 }
 }

 /* Will cancel an in-progress connection, and close the socket */
 public void cancel() {
 try {
 mySocket.close();
 } 
 catch (IOException e) {
 }
 }
}



private class SendReceiveBytes implements Runnable {
 private BluetoothSocket btSocket;
 private InputStream btInputStream = null;
 private OutputStream btOutputStream = null;
 String TAG = "SendReceiveBytes";

 public SendReceiveBytes(BluetoothSocket socket) {
 btSocket = socket;
 try {
 btInputStream = btSocket.getInputStream();
 btOutputStream = btSocket.getOutputStream();
 } 
 catch (IOException streamError) { 
 Log.e(TAG, "Error when getting input or output Stream");
 }
 }


 byte[] buffer = new byte[32]; // buffer store for the stream
 int numBytes = 0;
 
 public void run() {

//Reading Bluetooth data------------------------------------------------------
 // Keep listening to the InputStream until an exception occurs
 while (true) {
 try {
   
  if(BTReceiveMode == 0){  //Sampling mode
  
    while(btInputStream.available() > 31){ //read sets of 32 bytes
    
    numBytes = btInputStream.read(buffer,0,32);
    //receiveCount += numBytes;
    
    //print data
    readMessage = new String(buffer);  
    outputFile.println(readMessage);
    
    }
  }
   
 }
 catch (IOException e) {
 Log.e(TAG, "Error reading from btInputStream");
 break;
 }
 }
 
 //------------------------------------------------------------------------
 }


 /* Call this from the main activity to send data to the remote device */
 public void write(byte[] bytes) {
 try {
 btOutputStream.write(bytes);
 } 
 catch (IOException e) { 
 Log.e(TAG, "Error when writing to btOutputStream");
 }
 }


 /* Call this from the main activity to shutdown the connection */
 public void cancel() {
 try {
 btSocket.close();
 } 
 catch (IOException e) { 
 Log.e(TAG, "Error when closing the btSocket");
 }
 }
}

//Helpful Communication function to decode a float from a set of 4 hex bytes
float decodeFloat(String inString) {
  byte [] inData = new byte[4];

  if (inString.length() == 8) {
    inData[0] = (byte) unhex(inString.substring(0, 2));
    inData[1] = (byte) unhex(inString.substring(2, 4));
    inData[2] = (byte) unhex(inString.substring(4, 6));
    inData[3] = (byte) unhex(inString.substring(6, 8));
  }

  int intbits = (inData[3] << 24) | ((inData[2] & 0xff) << 16) | ((inData[1] & 0xff) << 8) | (inData[0] & 0xff);
  return Float.intBitsToFloat(intbits);
}


