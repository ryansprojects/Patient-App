class selectionPage {
 
  TextArea dateField;
  TextArea timeField;
  
  TextArea instrField;
  
  Button1 topSelect;
  Button1 bottomSelect;
  Button1 prevButton;
  Button1 nextButton;
  
  
  //Text field for exercise selections
  TextArea topType;
  TextArea topFreq;
  TextArea topDuration;
  
  TextArea bottomType;
  TextArea bottomFreq;
  TextArea bottomDuration;
  
  
  String dateString;
  String timeString;
  
  
  int state;
  int currentRow; //row of table being looked at
  
  int topSelectRow, bottomSelectRow; //row corresponding to button selection
 
  selectionPage(){
    
    state = 0;
    currentRow = 0;
    
    //Get date and time
    dateString = getDate(0);
    timeString = getTime(0);
    dateField = new TextArea(30,60, 700, 300, "Today is " + dateString,45);
    dateField.setAlign(LEFT);
    
    timeString = getTime(0);
    timeField = new TextArea(570,170,200,300, timeString, 45);
    timeField.setAlign(RIGHT);
    
    //Instructions
    instrField = new TextArea(50,170,600,300,"Please Select Exercise ",45, color(255,105,97));
    instrField.setAlign(LEFT);
    
    //Setup buttons
    topSelect = new Button1(645, 485, 100, 80, "Select");
    bottomSelect = new Button1(645, 855, 100, 80, "Select");
    topSelect.setBgColor(color(119,221,119));
    bottomSelect.setBgColor(color(119,221,119));
    
    prevButton = new Button1(50, 1000, 300, 100, "Previous");
    nextButton = new Button1(450, 1000, 300, 100, "Next");
    
    //Text fields
    topType = new TextArea(60, 260, 600, 100, "", 50, color(125,167,217));
    topFreq = new TextArea(60, 330, 500, 100, "", 30, color(0));
    topDuration = new TextArea(60, 370, 500, 100, "", 30, color(0));
    topType.setAlign(LEFT);
    topFreq.setAlign(LEFT);
    topDuration.setAlign(LEFT);
    
    bottomType = new TextArea(60, 630, 600, 100, "", 50, color(125,167,217));
    bottomFreq = new TextArea(60, 700, 500, 100, "", 30, color(0));
    bottomDuration = new TextArea(60, 740, 500, 100, "", 30, color(0));
    bottomType.setAlign(LEFT);
    bottomFreq.setAlign(LEFT);
    bottomDuration.setAlign(LEFT);
    
    
  }
  
  void display(){
   
   //Green background 
   fill(196,223,155); //Green Pea
   rect(0,150,width,height-150);
   
   //Date and time fields
   dateField.display();  
   timeString = getTime(0);
   timeField.setText(timeString);
   timeField.display();
   
   //Instructions
   instrField.display();
   
   
   if(state == 0){
      
     if(!snd.isPlaying()){
      
      snd.reset();
      try {
        fd = assets.openFd("sound008.wav");
        snd.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
        snd.prepare();
        snd.start();
      } 
      catch (IllegalArgumentException e) {
        e.printStackTrace();
      } 
        catch (IllegalStateException e) {
        e.printStackTrace();
      } catch (IOException e) {
        e.printStackTrace();
      }
      
       
     }
     
     //Attemp to load patient data
     try {
        patientExercisesTable = loadTable(SERVER + patientID + "_exercise.csv", "header"); //Load exercises
      } catch(NullPointerException e) {
        state = 100; //terminate
      } catch(ArrayIndexOutOfBoundsException e){ //error checking not really working
        state = 100; 
      }
     
      
     state = 1; //wait for snd player to finish
    
     
     
   }else if(state == 1){ //wait until sound player is done
     
     if(!snd.isPlaying()){ 
       state = 2;
      
     }
     
   }else if(state == 2){ //Load set of two exercises(if available or one)
     
     
     //is there a first exercise to put on top
     if(currentRow < patientExercisesTable.getRowCount()){
       
       //Set values
       topType.setText(patientExercisesTable.getString(currentRow,0));
       topFreq.setText(patientExercisesTable.getString(currentRow,1));
       topDuration.setText(patientExercisesTable.getString(currentRow,2));
       
       topSelectRow = currentRow;  //choose button to select row 0 (or currentRow)
       
       currentRow++;
     }
     
     //is there a second exercise to put on bottom
     if(currentRow < patientExercisesTable.getRowCount()){
       
       //set values for bottom selection
       bottomType.setText(patientExercisesTable.getString(currentRow,0));
       bottomFreq.setText(patientExercisesTable.getString(currentRow,1));
       bottomDuration.setText(patientExercisesTable.getString(currentRow,2));
       
       bottomSelectRow = currentRow;
       currentRow++;
     }
     
     state = 3;
     
     
   }else if(state == 3){ //Show selection, buttons, and wait
    
     if(((currentRow+1)%2) == 0){ //even row so draw only one selection box
     
       //draw yellow boxes
       fill(255,247,153);
       rect(50,250,700,320,10,10,0,0); //top
       
       topType.display();
       topFreq.display();
       topDuration.display();
       
       topSelect.display();
       topSelect.update();
       
     }else{ //odd row so draw two boxes
     
       //draw yellow boxes
       fill(255,247,153);
       rect(50,250,700,320,10,10,0,0); //top
       rect(50,620,700,320,10,10,0,0); //bottom
       
       topType.display();
       topFreq.display();
       topDuration.display();
  
       bottomType.display();
       bottomFreq.display();
       bottomDuration.display();
       
       topSelect.display();
       bottomSelect.display();
       
       topSelect.update();
       bottomSelect.update();
     
       
     }
     
     
     //if there are more rows available show next button
     if(currentRow <  patientExercisesTable.getRowCount()){
        nextButton.display();
        nextButton.update();
     }
     
     //if there are 2 previous rows avaiable show prev button
     if((currentRow - 2) > 0){
        prevButton.display();
        prevButton.update();
     }
     
     
     //Check buttons
     
     if(topSelect.clicked()){
     
       //top button has been pressed
       String duration = patientExercisesTable.getString(topSelectRow,2); //get duration of exercise string
       String [] parsed  = split(duration, ' ');
       exerciseDuration = Integer.parseInt(parsed[0]) * 1000; //in millisec
       exerciseName = patientExercisesTable.getString(topSelectRow,0);
       
       //Go to sampling window
       currWindow = 3;
       
     }else if(bottomSelect.clicked()){
       
       //bottom button has been pressed
       String duration = patientExercisesTable.getString(bottomSelectRow,2);
       String [] parsed  = split(duration, ' ');
       exerciseDuration = Integer.parseInt(parsed[0]) * 1000; //in millisec
       exerciseName = patientExercisesTable.getString(bottomSelectRow,0);
       
       //Go to sampling window
       currWindow = 3;
       
       
       
     }else if(prevButton.clicked()){
       
       //Go to debounce state for this button
       //which should take you back to state 2 (read set of exercises)
       
       if(((currentRow+1)%2) == 0){ //even row so go back 3 rows
         currentRow -= 3;
       }else{ //odd row go back 4 rows
         currentRow -= 4;
       }
       
       if(currentRow < 0){ currentRow = 0;} //make sure it is positive
     
       state = 10; //Go to debounce state for button
       
     }else if(nextButton.clicked()){
       
       //Go to debounce state for this button
       //which should take you back to state 2 (read set of exercises)
       state = 11;
       
     }
     
   }else if(state == 4){
     
   }else if(state == 10){//Debounce for prev button
     
     prevButton.display();
     prevButton.update();
     
     if(!prevButton.clicked()){
       state = 2;        //go to read next set of exercises
     }
   
   }else if(state == 11){//Debounce for next button
     
     nextButton.display();
     nextButton.update();
     
     if(!nextButton.clicked()){
       state = 2;        //go to read next set of exercises
     }
   
   }else if(state == 100){//Terminate state (data was not found)
    
     instrField.setText("Your information was not found!");
     
     snd.reset();
      try {
        fd = assets.openFd("sound021.wav"); //"Succesful connection"
        snd.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
        snd.prepare();
        snd.start();
      } 
      catch (IllegalArgumentException e) {
        e.printStackTrace();
      } 
        catch (IllegalStateException e) {
        e.printStackTrace();
      } catch (IOException e) {
        e.printStackTrace();
      }
      
      state = 101;
     
     
   }else if(state == 101){//close application
     
     if(!snd.isPlaying()){
       //Terminate app after snd ends
       exit();
     }
     
   }
   
  }//display()
  
}
