int ellapsedTime;                     // time ellapsed before pause (millisec)
float freqAvg, freqAvgCounter;


class samplingPage {

  int state, nextState;


  String dateString;
  String timeString;
  String resultsID;
  String filenameResults;

  Button1 startButton;
  Button1 stopButton;


  TextArea rateFeedback, positionFeedback, styleFeedback;
  TextArea timerDisplay, confirmExit, confirmReset;
  TextArea rollDisplay, pitchDisplay, yawDisplay, timeDisplay, freqDisplay;
  TextArea timeDisplayO, freqDisplayO, yawDisplayO, rollDisplayO, pitchDisplayO, timeDisplay1, timeDisplayO1;
  TextArea freqDisplayT, freqDisplayTO, freqDisplay1;
  TextArea finishDisplay, uploadDisplay;
  TextArea axisMovement, freqTitle, timeTitle;

  // FREQUENCY CALUCLATION
  float dimMax, dim;
  boolean direction;
  int fCounter;
  int freqTimer, freqEnd;
  float freq;

  // server display
  int wait = 0;



  int startTime;    // begin timer time
  int countdownTime;// time remaining
  int resumeTime;
  String minS, secS, csecS, minSE, secSE, csecSE;
  int min, sec, csec, updateTimer;
  char degree = 0x00B0;
  ;
  float frequency, theta;
  float averageFreq;
  int freqCount;
  int rounder;
  String good, average, poor;

  samplingPage() {

    state = 0;
    nextState = 0;
    freqAvgCounter = 0;
    freqAvg = 0.0;

    good = "Good";
    average = "Average";
    poor = "Poor";

    // Frequency parameters
    direction = true;
    fCounter = 0;
    dimMax = 0;
    freqTimer = 0;
    freqEnd = 0;


    //Timer parameters
    timerDisplay = new TextArea(50, 150, 700, 300, "0:00", 200);
    freqDisplay = new TextArea(50, 800, 700, 150, "Frequency: ", 50);

    uploadDisplay = new TextArea(50, 150, 700, 300, "Your data is being uploaded to the server....", 100);


    startButton = new Button1(50, 1000, 300, 100, "Start");
    startButton.setBgColor(color(119, 221, 119));
    stopButton = new Button1(450, 1000, 300, 100, "Stop");
  }

  void display() {

    //Green background 
    fill(196, 223, 155); //Green Pea
    rect(0, 150, width, height-150);


    noStroke();

    //Determine sample and euler angles
    if (readMessage.length() > 15) {
      sample = decodeFloat(readMessage.substring(0, 8));
      yaw = decodeFloat(readMessage.substring(8, 16))*180/PI;
      //Determine sample and euler angles
      pitch = decodeFloat(readMessage.substring(16, 24))*180/PI;
      if(yaw > 90) {
        yaw = 90;
      } else if (yaw < -90) {
        yaw = -90;
      }
      if (pitch > 90) {
        pitch = 90;
      } else if (pitch < -90) {
        pitch = -90;
      }
      // roll = decodeFloat(readMessage.substring(24, 32));
    }

    noFill();
    stroke(0);
    strokeWeight(2);
    rect(374,375,52,400);
    rect(200,549,400,52);
    strokeWeight(1);
    noStroke();
    
    fill(255, 100, 100);
    rect(400,550,map(yaw, -90, 90, -200, 200),50); //yaw
    
    fill(100, 230, 100);
    rect(375,575,50,map(-pitch, -90, 90, -200, 200)); //pitch
    
    fill(190,190,190);
    rect(375,550,50,50);

    // prior to 4-23
    // fill(255, 100, 100);
    // rect(200, 700, 100*yaw, 50);

    // fill(100, 255, 100);
    // rect(200, 600, 50, 100*pitch);

    // fill(100, 100, 255);
    // arc(500, 600, 100, 100, 0, roll+(PI/2), PIE);
    // /end prior to 4-23



    //-------States

    if (state == 0) {
      //Show exercise duration
      timerDisplay.setText(num2str(exerciseDuration));
      timerDisplay.display();
      ellapsedTime = 0;

        //Play audio
       snd.reset();
        try {
          fd = assets.openFd("sound030.wav");
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
        
        snd.start();

      // DETERMINE WHAT TYPE OF EXERCISE BEING PERFORMED
      if (PITCH_EXERCISE_STRING.equals(exerciseName)) {
        PITCH_EXERCISE = true;
        YAW_EXERCISE = false;
      }
      else if (YAW_EXERCISE_STRING.equals(exerciseName)) {
        PITCH_EXERCISE = false;
        YAW_EXERCISE = true;
      }

      //Play audio
      state = 1;
    }
    else if (state == 1) {//waiting on start

      //Show exercise duration
      timerDisplay.setText(num2str(exerciseDuration));
      timerDisplay.display();

      //Update show start button
      startButton.update();
      startButton.display();

      if (startButton.clicked()) {
        state = 10;
        nextState = 2;  //enter sampling state
      }
    }
    else if (state == 2) {//begin sampling state

      //Get starting date and time
      dateString = getDate(1); //in format mm/dd/yyyy
      timeString = getTime(1); //in format hhmmss

      //Create data points file with filename format: ID_results_mmddhhmmAM.txt
      String [] parseDate = split(dateString, "/");
      String [] parseTime = split(timeString, ":");
      resultsID = patientID + "_results_" + parseDate[0] + parseDate[1] + parseTime[0] + parseTime[1] + parseTime[2] + ".txt";
      filenameResults = "//sdcard//AppData//" + resultsID ;
      outputFile = createWriter(filenameResults);

      BTReceiveMode = 0; //start sampling mode (listening)
      //Send byte 'S' to headset
      byte[] myByte = stringToBytesUTFCustom("S");
      sendReceiveBT.write(myByte);


      state = 3;
      updateTimer = millis();
      startTime = millis();
    }
    else if (state == 3) {//wait for stop command (timer or user)

      //Update show stop button
      stopButton.update();
      stopButton.display();


      //Update Timer and Feedback===========================

      if ((millis() - updateTimer) >= 250) {  // update these every 500 ms.
        updateTimer = millis();
        if (YAW_EXERCISE) {
          freqDisplay.setText("Yaw Frequency: "+freq+" Hz.");
        }
        else if (PITCH_EXERCISE) {
          freqDisplay.setText("Pitch Frequency: "+freq+" Hz.");
        }
        freqAvg += freq;
      }

      // ===================FREQUENCY LOGIC=====================
      // Incrementer logic for recording frequency
      if (PITCH_EXERCISE) {
        dim = pitch;
      }
      else if (YAW_EXERCISE) {
        dim = yaw;
      }

      if ((dim>dimMax) && direction) {
        dimMax = dim;
      }
      else if ((dim<dimMax) && !direction) {
        dimMax = dim;
      }
      else if ((dim<dimMax) && direction) {
        fCounter++;
      }
      else if ((dim>dimMax) && !direction) {
        fCounter++;
      }

      // Record frequency, reset period timer, reverse logic
      if (fCounter > 5) {
        direction = !direction;
        fCounter = 0;
        freqEnd = millis() - freqTimer - 25;     // correct for head turning 5 samples ago (5/200*1000)
        freq = 5000.0/freqEnd;                   // 10* (1/(2 * freqEnd/1000)) = 5000.0 / freqEnd
        freq = (int) freq;
        freq = freq/10;                          // convert to x.x Hz
        freqTimer = millis();
      }

      ellapsedTime = millis() - startTime;
      countdownTime = (exerciseDuration - ellapsedTime);
      timerDisplay.setText(num2str(countdownTime));
      timerDisplay.display();
      freqDisplay.display();

      if (ellapsedTime >= exerciseDuration) {
        state = 12; //stop sampling and display server upload
        nextState = 4;
      }

      if (stopButton.clicked()) {
        state = 11;
        nextState = 4;
      }
    }
    else if (state == 4) {//stop sampling and save file

      background(backgroundColor);
      uploadDisplay.display();

      // snd.reset();
      // try {
      //   fd = assets.openFd("sound032.wav");
      //   snd.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
      //   snd.prepare();
      //   snd.start();
      // } 
      // catch (IllegalArgumentException e) {
      //   e.printStackTrace();
      // } 
      // catch (IllegalStateException e) {
      //   e.printStackTrace();
      // } 
      // catch (IOException e) {
      //   e.printStackTrace();
      // }

      
      // ===== Calculate Average Frequency =====
      freqAvg = 10.0*freqAvg / (ellapsedTime/250.0);
      freqAvg = (int) freqAvg;
      freqAvg = freqAvg / 10;

      //Send byte 'N'
      byte[] myByte = stringToBytesUTFCustom("N");
      sendReceiveBT.write(myByte);

      BTReceiveMode = 1;

      //Add data entry to patient results
      String durationOfExercise = (ellapsedTime/1000) + " seconds"; //compute time in excersice

      patientResultsTable = loadTable(SERVER + patientID + "_results.csv", "header");
      TableRow newRow = patientResultsTable.addRow();
      newRow.setString("Date", dateString);
      newRow.setString("Time", timeString);
      newRow.setString("Duration", durationOfExercise);
      newRow.setString("Name", exerciseName);
      newRow.setString("Filename", resultsID);

      //Save results entry table locally
      saveTable(patientResultsTable, "//sdcard//AppData//" + patientID + "_results.csv");
      saveToWeb("//sdcard//AppData//" + patientID + "_results.csv"); //upload to server

      //Save data points file locally
      outputFile.flush();
      outputFile.close();
      saveToWeb(filenameResults); //upload to server

      state = 0;

      //Go to next window (results)
      currWindow = 4;
    }
    else if (state == 10) { //start button wait release

      startButton.update();
      startButton.display();
      stopButton.update();
      stopButton.display();

      if (!startButton.clicked()) { //Button is unpressed
        state = nextState;
      }
    }
    else if (state == 11) { //stop button wait release

      stopButton.update();
      background(backgroundColor);
      uploadDisplay.display();

      if (!stopButton.clicked()) { //Button is unpressed
        state = nextState;
      }
    }
    else if (state == 12) {
      background(backgroundColor);
      uploadDisplay.display();
      wait = millis();
      while ( (millis () - wait)>10) {
        ;
      }
      state = nextState;
    }
    else {
      //Do nothing
      background(255);
    }
  }
}


String num2str(int t) {
  int min = t/60000;
  String minS = min+"";
  int sec = (t - (min*60000))/1000;
  String secS = sec+"";
  int csec = (t - (min*60000) - (sec*1000))/10;
  String csecS = csec+"";
  if (sec < 10) {
    secS = "0"+sec;
  }
  else {
    secS = sec+"";
  }
  if (csec < 10) {
    csecS = "0"+csec;
  }
  else {
    csecS = csec+"";
  }
  return minS+":"+secS+":"+csecS;
}

