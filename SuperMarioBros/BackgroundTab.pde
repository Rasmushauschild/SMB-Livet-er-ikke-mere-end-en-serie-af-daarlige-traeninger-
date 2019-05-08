//Declare images for backgroundTab. Images are assigned in setup.
PImage bushSmall; //ID: 40
PImage bushMedium; //ID: 41
PImage bushBig; //ID: 42
PImage hillSmall; //ID: 43
PImage hillBig; //ID: 44
PImage cloudSmall; //ID: 45
PImage cloudBig; //ID: 46
PImage castle; //ID: 47

class Background{ //class containing functionality used in all non-interactable scene elements
  float startPosX; //Original horizontal position
  float posX; //horizontal position updated by scrollAmount
  float posY; //vertical positiona
  int identifier; //Identifier determining what type of background element each instance of this class should become

  Background(float tempX, float tempY, int tempIdentifier){ //Class initializer
    startPosX = tempX;
    posX = tempX;
    posY = tempY;
    identifier = tempIdentifier;
    
  }
  void Display(){ //Function responsible for displaying each background element at the correct location
    posX = startPosX-scrollAmount; //Updates the horizontal position with scrollAmount
    
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
      image(hillBig, posX, posY - 16);
      break;
      
      case 45: //Small Cloud
      image(cloudSmall, posX, posY);
      break;
      
      case 46: //Big Cloud
      image(cloudBig, posX, posY);
      break;
      
      case 47: //Castle
      image(castle, posX, posY - 60);
      break;
    }
  }
}
