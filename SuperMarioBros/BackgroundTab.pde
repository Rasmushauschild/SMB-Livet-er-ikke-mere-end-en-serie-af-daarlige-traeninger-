class BackgroundColor{  
  int red;
  int green;
  int blue;
  
  
      BackgroundColor(int tempRed, int tempGreen, int tempBlue){
      red = tempRed;
      green = tempGreen;
      blue = tempBlue;
      
    }
  
    void Display(){
      fill(red, green, blue);
      rect(0,0,width,height);
    }
    
}
