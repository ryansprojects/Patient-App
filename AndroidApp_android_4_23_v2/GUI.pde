

//Text Box/Are to write text to
//Parameters x-coord, y-coord, width, height, text, size, color
//Additional parameters: color C, font size
class TextArea {
   String textString;
   int xpos, ypos;
   int swidth, sheight;
   color fontColor;
   int fontSize;
   int alignment;
   
   TextArea(int xp, int yp, int w, int h, String text){
    
     textString = text;
     xpos = xp;
     ypos = yp;
     swidth = w;
     sheight = h;
     
     //Default values
     fontSize = 12;
     fontColor = color(255,255,255); //white
     alignment = CENTER;
     
   }
   
   TextArea(int xp, int yp, int w, int h, String text, int size){
    
     textString = text;
     xpos = xp;
     ypos = yp;
     swidth = w;
     sheight = h;
     fontSize = size;
     fontColor = color(255,255,255); //white default
     alignment = CENTER; //default
     
   }
   
   TextArea(int xp, int yp, int w, int h, String text, int size, color C){
    
     textString = text;
     xpos = xp;
     ypos = yp;
     swidth = w;
     sheight = h;
     fontColor = C;
     fontSize = size;
     alignment = CENTER;
     
   }
   
   void display(){
    
     fill(fontColor);
     textSize(fontSize);
     textAlign(alignment);
     text(textString,xpos,ypos,swidth,sheight);
     
   }
 
   void setText(String txt){
     textString = txt;
   }
   
   void setSize(int s){
     fontSize = s;
   }
   
   void setColor(color c){
     fontColor = c;
   }
   
   void setAlign(int align){
     alignment = align; 
   }
  
}

//Type 1 Button: General Button mainly used for navigation
//Parameters: x,y coordinates, width, height, text
//Optional Paramters: background and text color;
class Button1 {
  int xpos, ypos;       // x and y position of button
  int swidth, sheight;    // width and height of button
  
  boolean over;           // is the mouse over button
  boolean clicked;        // is mouse being clicked
  String textField;
  color bgColor;
  color textColor;

  Button1 (int xp, int yp, int sw, int sh, String text) {
    xpos = xp;
    ypos = yp;
    swidth = sw;
    sheight = sh;
    textField = text;
    
    //Defualt values
    over= false;
    clicked = false;
    bgColor = color(255,105,97);     //red
    textColor = color(255,255,255); //white
  }
  
  Button1 (int xp, int yp, int sw, int sh, String text, color bg, color txtColor) {
    xpos = xp;
    ypos = yp;
    swidth = sw;
    sheight = sh;
    textField = text;
    
    //Defualt values
    over= false;
    clicked = false;
    bgColor = bg;
    textColor = txtColor;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } 
    else {
      over = false;
    }
    if (mousePressed && over) {
      clicked = true;
    }
    if (!mousePressed) {
      clicked = false;
    }
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } 
    else {
      return false;
    }
  }
  
  boolean clicked(){
    return clicked;
  }

  void display() {
    
    stroke(5);
    if (clicked) {
      fill(0, 0, 0);
    } 
    else {
      fill(bgColor);
    }
    rect(xpos, ypos, swidth, sheight,10,10,10,10);
    fill(textColor);
    textSize(sheight-50);
    textAlign(CENTER,CENTER);
    text(textField, xpos, ypos, swidth, sheight);
  }
  
  void setBgColor(color c){
     bgColor = c; 
  }
  
  void setText(String t){
    textField = t; 
  }
  
}


//Green Loading Bar
//Parameters: x-coord, y-coord, width, height
class LoadingBar {
  float percent; 
  int xpos, ypos;
  int swidth, sheight;
  color barColor;
  
  LoadingBar(int xp, int yp, int w, int h){
   percent = 0;
   xpos = xp;
   ypos = yp;
   swidth = w;
   sheight = h;
  }
  
  void display(){
    stroke(5);
    fill(40,120,0);
    rect(xpos,ypos,swidth,sheight,5,5,5,5);
    fill(80,230,0);
    rect(xpos,ypos,percent*swidth,sheight,5,5,5,5);
  }
  
  void setVal(float per){
    percent = per;
  }
  
}


//Function to read date from device
String getDate(int format){
 
   int month = deviceCalendar.get(Calendar.MONTH);
   int day = deviceCalendar.get(Calendar.DAY_OF_WEEK);
   int date = deviceCalendar.get(Calendar.DAY_OF_MONTH);
   int year = deviceCalendar.get(Calendar.YEAR);
   String monthString;
   String dayString;
   
  if(format == 0){ 
        switch (day) {
                  case 1:  dayString = "Sunday";
                           break;
                  case 2:  dayString = "Monday";
                           break;
                  case 3:  dayString = "Tuesday";
                           break;
                  case 4:  dayString = "Wednesday";
                           break;
                  case 5:  dayString = "Thursday";
                           break;
                  case 6:  dayString = "Friday";
                           break;
                  case 7:  dayString = "Saturday";
                           break;
                  default: dayString = "Invalid day";
                           break;
        } 
         
        switch (month) {
                  case 0:  monthString = "January";
                           break;
                  case 1:  monthString = "February";
                           break;
                  case 2:  monthString = "March";
                           break;
                  case 3:  monthString = "April";
                           break;
                  case 4:  monthString = "May";
                           break;
                  case 5:  monthString = "June";
                           break;
                  case 6:  monthString = "July";
                           break;
                  case 7:  monthString = "August";
                           break;
                  case 8:  monthString = "September";
                           break;
                  case 9: monthString = "October";
                           break;
                  case 10: monthString = "November";
                           break;
                  case 11: monthString = "December";
                           break;
                  default: monthString = "Invalid month";
                           break;
        }
        
        return dayString + " " + monthString + " " + date;
        
  }else if(format == 1){//Format mm/dd/yyyy
    
    month += 1;
    
    if(month < 10 && date > 10){
      return "0" + month + "/" + date + "/" + year;
    }else if(month > 9 && date < 10){
      return month + "/" + "0" + date + "/" + year;
    }else{
      return month + "/" + date + "/" + year;
    }
      
  }
  
  return "";
  
}

String getTime(int format){
  
  int hour = hour();
  int min = minute();
  int am = deviceCalendar.get(Calendar.AM_PM);
  int sec = second();
  
  
  String AM;
  String time;
  
  if(am == 0){
    AM = "AM";
  }else{
    AM = "PM";
  }
  
  if(format == 0){//format = 0
      if(min < 10 && hour < 10){
        
        time = "0" + hour + ":" + "0" + min + AM;
        
      }else if (min > 10 && hour < 10){
        
        time = "0" + hour + ":" +  min + AM;
      }else if (min < 10 && hour > 10){
        time = hour + ":" +  min + AM;
      }else{
        
        time = hour + ":" + min + AM;
        
      }
  }else{ //format = 1
  
      String secS = sec + "";
      
      if(sec < 10){ secS = "0"+secS;}
  
      if(min < 10 && hour < 10){
        
        time = "0" + hour + ":" + "0" + min + ":" + secS + AM;
        
      }else if (min > 10 && hour < 10){
        
        time = "0" + hour + ":" +  min + ":" + secS + AM;
      }else if (min < 10 && hour > 10){
        time = hour + ":" +  min + ":" + secS + AM;
      }else{
        
        time = hour + ":" + min + ":" + secS + AM;
        
      }
  }
  
  return time;
  
}

