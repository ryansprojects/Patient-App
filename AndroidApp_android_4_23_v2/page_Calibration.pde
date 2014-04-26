
class calibrationPage {

  TextArea countdown;
  TextArea instructions;

  Button1 continueButton;

  int state, count, timer;

  calibrationPage() {
    countdown = new TextArea(0, 225, 800, 1200, "3", 400);
    instructions = new TextArea(100, 250, 600, 600, "Please look straight ahead!", 75);
    continueButton = new Button1(250, 1000, 300, 100, "Continue"); // fix me

    timer = 3;  //3 seconds
    state = -2;
  }


  void display() {
    
    if(state == -2){
      
      snd.reset();
      try {
        fd = assets.openFd("sound014.wav");
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
      snd.start();
      
      state = -1;
      
    }else if(state == -1){
     
     instructions.display();
      
     if(!snd.isPlaying()){
       state = 0;
       count = millis();
     }
    
    }else if (state == 0) {
     
     background(255,20,20); 
      
     countdown.display();

      if ((millis() - count) > 1000) {
        timer--;
        countdown.setText(timer+"");
        count = millis();
      }
      if (timer < 0) {
        
        //Send calibration command to Headset
        byte[] myByte = stringToBytesUTFCustom("C");
        sendReceiveBT.write(myByte);
        
        
        instructions.setText("Calibrated!");
        state = 1;
      }
      
    }else if (state == 1) {
      
      instructions.display();
      
      //Load success audio
      snd.reset();
      try {
        fd = assets.openFd("sound015.wav");
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
      snd.start();
      
      state = 2;
      
    }else if(state == 2){
      
      instructions.display();
      if(!snd.isPlaying()){
        timer = 5;
        state = -1;
        countdown.setText(timer+"");
        currWindow = 2;
      }
     
    }
  }
}
