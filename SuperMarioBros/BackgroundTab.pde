//Declare images for backgroundTab. Images are assigned in setup.
PImage bushSmall; //40
PImage bushMedium; //41
PImage bushBig; //42
PImage hillSmall; //43
PImage hillBig; //44
PImage cloudSmall; //45
PImage cloudBig; //46
PImage castle; //?

class Background{
  float startPosX;
  float posX;
  float posY;
  int identifier;
  

    
  Background(float tempX, float tempY, int tempIdentifier){
    startPosX = tempX;
    posX = tempX;
    posY = tempY;
    identifier = tempIdentifier;
    
  }
  void Display(){
    posX = startPosX-scrollAmount;
    
    switch (identifier){
      case 40: //Small Bush
      image(bushSmall, posX, posY);
      break;
      
      case 41: //Medium Bush
      image(bushMedium, posX, posY);
      break;
      
      case 42: //Big Bush
      image(bushBig, posX, posY);
      break;
      
      case 43: //small Hill
      image(hillSmall, posX, posY);
      break;
      
      case 44: //Big Hill
      image(hillBig, posX, posY-16);
      break;
      
      case 45: //Small Cloud
      image(cloudSmall, posX, posY);
      break;
      
      case 46: //Big Cloud
      image(cloudBig, posX, posY);
      break;
    }
  }
}
