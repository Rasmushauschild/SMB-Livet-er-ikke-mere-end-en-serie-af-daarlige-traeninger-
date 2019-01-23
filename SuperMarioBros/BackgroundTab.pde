class Background{
    int red;
    int green;
    int blue;
     
    Background(){ 
    }
    
    void Display(int tempRed, int tempGreen, int tempBlue){
      red = tempRed;
      green = tempGreen;
      blue = tempBlue;
      
      background(red, green, blue);
    }
    
}
