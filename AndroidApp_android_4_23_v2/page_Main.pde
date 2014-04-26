import android.media.*;
import android.content.res.*;


//Sound player objects
MediaPlayer snd;
AssetManager assets;
AssetFileDescriptor fd;



class mainPage {

  PImage img;  // Declare variable of type PImage for logo

  Button1 contButton;
  LoadingBar loadBar;
  TextArea messageField;

  APEditText textField; //Text field for user ID


  int state; //state of window state 0,1,2,3,4 etc.

  mainPage() {

    img = loadImage("logo.png");
    contButton = new Button1(225, 870, 300, 100, "Continue");
    loadBar = new LoadingBar(130, 550, 500, 30);
    messageField = new TextArea(130, 650, 500, 300, "Welcome to Head Motion Monitoring System", 30);

    textField = new APEditText( 330, 700, 100, 50 );
    textField.setInputType(InputType.TYPE_CLASS_NUMBER);//Number only
    textField.setCloseImeOnDone(true); //close the IME when done is pressed
    
    state = 0;
  }


  void display() {

    image(img, width/4, height/6, 690, 255);  //logo image
    messageField.display();
    loadBar.display();

    //States-----------------------------------------------------

    if (!snd.isPlaying()) { //While the media player is free

      if (state == 0) { //Welcome message
        snd.start();
        state = 1;
        loadBar.setVal(0.1);
        
      }
      else if (state == 1) { //load next sample
        //"Bluetooth is not enabled.Please enable bluetooth"
        snd.reset();
        try {
          fd = assets.openFd("sound004.wav");
          snd.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
          snd.prepare();
        } 
        catch (IllegalArgumentException e) {
          e.printStackTrace();
        } 
        catch (IllegalStateException e) {
          e.printStackTrace();
        } 
        catch (IOException e) {
          e.printStackTrace();
        }
        loadBar.setVal(0.15);
        state = 2;
      }
      else if (state == 2) {// Check if bluetooth is enabled

        /*IF Bluetooth is NOT enabled, then ask user permission to enable it */
        if (!bluetooth.isEnabled()) {
          state = 3;
        }


        /*If Bluetooth is now enabled, then register a broadcastReceiver to report any
         discovered Bluetooth devices, and then start discovering */
        if (bluetooth.isEnabled()) {
          try {
            registerReceiver(myDiscoverer, new IntentFilter(BluetoothDevice.ACTION_FOUND));
            registerReceiver(checkIsConnected, new IntentFilter(BluetoothDevice.ACTION_ACL_CONNECTED));
            state = 5 ;
          } catch(Exception e) {
            e.printStackTrace();
          }
        }

        loadBar.setVal(0.2);
      }
      else if (state == 3) {//Play audio "No bluetoth is enabled

        snd.start();
        state = 4;
      }
      else if (state == 4) {//Ask for permission to enable bluetooth

        //Ask for permission to enable bluetooth
        Intent requestBluetooth = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
        startActivityForResult(requestBluetooth, 0);
        state = 2;
      }
      else if (state == 5) {//Start Discovering Devices

        //Start bluetooth discovery if it is not doing so already
        if (!bluetooth.isDiscovering()) {
          bluetooth.startDiscovery();
        }
        loadBar.setVal(0.45);
        state = 6;
      }
      else if (state == 6) {//delay and wait for discovery

        snd.reset();
        try {
          fd = assets.openFd("sound002.wav");
          snd.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
          snd.prepare();
        } 
        catch (IllegalArgumentException e) {
          e.printStackTrace();
        } 
        catch (IllegalStateException e) {
          e.printStackTrace();
        } 
        catch (IOException e) {
          e.printStackTrace();
        }

        delay(4000); //1.0 sec
        state = 7;
      }
      else if (state == 7) {//check if device was found

        if (foundDevice) {
          snd.start();
          state = 9;
          loadBar.setVal(0.7);
        }
        else {
          state = 8;
        }
      }
      else if (state == 8) {//play device was not found check it

        snd.reset();
        try {
          fd = assets.openFd("sound005.wav");
          snd.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
          snd.prepare();
          snd.start();
        } 
        catch (IllegalArgumentException e) {
          e.printStackTrace();
        } 
        catch (IllegalStateException e) {
          e.printStackTrace();
        } 
        catch (IOException e) {
          e.printStackTrace();
        }

        state = 5;
      }
      else if (state == 9) {//delay some to allow device to connect

        snd.reset();
        try {
          fd = assets.openFd("sound006.wav"); //"device eas unable to connect. restart"
          snd.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
          snd.prepare();
        } 
        catch (IllegalArgumentException e) {
          e.printStackTrace();
        } 
        catch (IllegalStateException e) {
          e.printStackTrace();
        } 
        catch (IOException e) {
          e.printStackTrace();
        }

        delay(500); //0.5 sec
        state = 10;
      }
      else if (state == 10) {//check connection to headset

        if (BTisConnected) {
          loadBar.setVal(1.0);
          state = 12;
        }
        else {
          state = 11;
        }
      }
      else if (state == 11) {//Unable to connect. try again.

        snd.start();
        state = 9;
      }
      else if (state == 12) {//Play succesful connection

        snd.reset();
        try {
          fd = assets.openFd("sound007.wav"); //"Succesful connection"
          snd.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
          snd.prepare();
          snd.start();
        } 
        catch (IllegalArgumentException e) {
          e.printStackTrace();
        } 
        catch (IllegalStateException e) {
          e.printStackTrace();
        } 
        catch (IOException e) {
          e.printStackTrace();
        }
        state = 13;
      }
      else if (state == 13) {//Play instructions to enter ID
        
        if(!snd.isPlaying()){
          
          snd.reset();
          try {
            fd = assets.openFd("sound025.wav"); //"Succesful connection"
            snd.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
            snd.prepare();
            snd.start();
          } 
          catch (IllegalArgumentException e) {
            e.printStackTrace();
          } 
          catch (IllegalStateException e) {
            e.printStackTrace();
          } 
          catch (IOException e) {
            e.printStackTrace();
          }
        
          messageField.setText("Enter Patient ID");
          container.addWidget(textField); //show field
          state = 14;
        }
        
        
       
      }
      else if (state == 14) { //wait for track to finish
        
        if(!snd.isPlaying()){state = 15;}  
        
      }
      else if (state == 15) {//Show button and text field

        //Show button and check it
        contButton.update();
        contButton.display();

        if (contButton.clicked()) {
          
          //Proccess user ID
          patientID = textField.getText();
          
          if(patientID == ""){
            messageField.setText("Enter Your ID Please");
          }else if(patientID.length() < 3){
            messageField.setText("Enter Valid 3-Digit ID Please");
          }else{
            
            container.removeWidget(textField); //show field
            
            //Continue to next window
            currWindow = 1;
          
          }
          
        }
      }
    }
  }
}

