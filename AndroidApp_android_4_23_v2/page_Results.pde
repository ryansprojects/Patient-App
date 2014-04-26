class resultsPage {

  String good, average, poor;

  TextArea rateFeedback, positionFeedback, styleFeedback;
  TextArea timerDisplay;
  TextArea rollDisplay, pitchDisplay, yawDisplay, timeDisplay, freqDisplay;
  TextArea timeDisplayO, freqDisplayO, yawDisplayO, rollDisplayO, pitchDisplayO, timeDisplay1, timeDisplayO1;
  TextArea freqDisplayT, freqDisplayTO, freqDisplay1;
  TextArea finishDisplay;
  TextArea axisMovement, freqTitle, timeTitle;
  TextArea finishDisplayM;

  Button1 exitButton, homeButton;

  boolean soundPlayed = false;

  int state = 0;

  resultsPage() {

    homeButton = new Button1(250, 1000, 300, 100, "Home");

    finishDisplay = new TextArea(0, 100, 800, 150, "Good Job!", 120);
    finishDisplayM = new TextArea(100, 300, 600, 100, "Your data has been uploaded.", 40);

    timeTitle = new TextArea(0, 425, 800, 70, "EXERCISE DURATION", 60);
    timeDisplay = new TextArea(425, 500, 350, 100, "", 40);
    timeDisplay.setAlign(LEFT);
    timeDisplayO = new TextArea(0, 500, 375, 60, "ACTUAL", 40);
    timeDisplayO.setAlign(RIGHT);
    timeDisplayO1 = new TextArea(0, 575, 375, 60, "TARGET", 40);
    timeDisplayO1.setAlign(RIGHT);
    timeDisplay1 = new TextArea(425, 575, 350, 60, "", 40);
    timeDisplay1.setAlign(LEFT);

    freqTitle = new TextArea(0, 725, 800, 70, "FREQUENCY", 60);
    freqDisplay = new TextArea(425, 800, 350, 60, "", 40);
    freqDisplay.setAlign(LEFT);
    freqDisplayO = new TextArea(0, 800, 350, 60, "AVERAGE", 40);
    freqDisplayO.setAlign(RIGHT);
    freqDisplayT = new TextArea(0, 875, 350, 60, "TARGET", 40);
    freqDisplayT.setAlign(RIGHT);
    freqDisplayTO = new TextArea(425, 875, 150, 60, "", 40);
    freqDisplayTO.setAlign(LEFT);

  }

  void display() {

    //Play adudio one time
    if(!soundPlayed){
        snd.reset();
        try {
          fd = assets.openFd("sound031.wav");
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
        soundPlayed = true;
        snd.start();
     
    }

    timeDisplay1.setText(num2str(exerciseDuration));
    timeDisplay.setText(num2str(ellapsedTime));
    
    freqDisplay.setText(freqAvg+" Hz.");

    freqDisplay.display();
    timeDisplay.display();
    freqDisplayO.display();
    timeDisplayO.display();
    timeDisplayO1.display();
    timeDisplay1.display();
    timeTitle.display();
    freqDisplay.display();
    freqTitle.display();

    finishDisplay.display();
    finishDisplayM.display();
    homeButton.display();
    homeButton.update();

    if (homeButton.clicked()) {
      state = 1;
    }
    if (state == 1) {
      homeButton.update();
      homeButton.display();

      if (!homeButton.clicked()) {
        currWindow = 2;
        state = 0;
      }
    }
  }
}
