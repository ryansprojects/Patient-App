//Good version!!!!!!!!!!!!!!! 4/22/2013

import apwidgets.*;
import android.text.InputType;
import java.util.Calendar;
import java.net.*;
import java.io.*;

String SERVER = "http://gregmicek.com/4012/prod/file-test/uploads/";



///////////////////////////
//Window Parameters
/////////////////////////

//Window(panel) selector
//Chooses what to draw on screen
//and thus what window it is currently on
// 0 - Main Window
// 1 - Excercise Select
// 2 - Calibration
// 3 - Excersise View
int currWindow = 0;
mainPage page1;
calibrationPage page2;
selectionPage page3;
samplingPage page4;
resultsPage page5;

////////////////////////////
//Global Objects
////////////////////////////
//Libraries, classes global objects
Calendar deviceCalendar;     //object for date, time
PrintWriter outputFile;      //object to write files to storage

//Tables
Table patientExercisesTable;
Table patientResultsTable;

//////////////////////////
//Global Variables
//////////////////////////
String patientID;
int exerciseDuration;
int exerciseFreq;
String exerciseName;
boolean PITCH_EXERCISE, YAW_EXERCISE;        // identify what type of exercise is being performed
String YAW_EXERCISE_STRING, PITCH_EXERCISE_STRING;

float sample,roll,yaw,pitch;                //Euler angles being recieved
color backgroundColor = color(50,180,230);  //background color of app

APWidgetContainer container;

void setup(){
  
  size(800,1205);
  orientation(PORTRAIT);
  
  // Exercise Definitions
  YAW_EXERCISE_STRING = "Type 1";
  PITCH_EXERCISE_STRING = "Type 2";
  
  //Calendar
  deviceCalendar = Calendar.getInstance(); 
  
  //Initiate pages
  page1 = new mainPage();
  page2 = new calibrationPage();
  page3 = new selectionPage();
  page4 = new samplingPage();
  page5 = new resultsPage();
  
  //load welcome audio sample
  try {
    snd = new MediaPlayer();
    assets = this.getAssets();
    fd = assets.openFd("sound001.wav");
    snd.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    snd.prepare();
  } 
  catch (IllegalArgumentException e) {
    e.printStackTrace();
  } 
  catch (IllegalStateException e) {
    e.printStackTrace();
  } catch (IOException e) {
    e.printStackTrace();
  }
  
  //Setup container for widgets
  container = new APWidgetContainer( this );
  
  try {
    BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();    
    if (mBluetoothAdapter.isEnabled()) {
      mBluetoothAdapter.disable();
      delay(2000);
    }
    if (!mBluetoothAdapter.isEnabled()){
      mBluetoothAdapter.enable(); 
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
  
  
}


void draw(){
  
  background(backgroundColor);
  
  
  //Display the appropriate page
  if(currWindow == 0){// welcome window
    
   page1.display();
    
  }else if(currWindow == 1){//calibration page
   
    page2.display();
    
  }else if(currWindow == 2){ //exercise select page
   page3.display();
    
 }else if(currWindow == 3){ //sampling page
   page4.display();
 
 }else if(currWindow == 4){ // results page
   page5.display();
 }

}



