class Background{
  float startPosX;
  float posX;
  float posY;
  int identifier;
  
  PImage bushSmall = loadImage("Sprite_BushS"); //40
  PImage bushMedium = loadImage("Sprite_BushM"); //41
  PImage bushBig = loadImage("Sprite_BushL"); //42
  PImage hillSmall = loadImage("Sprite_HillS"); //43
  PImage hillBig = loadImage("Sprite_HillB"); //44
  PImage cloudSmall = loadImage("Sprite_CloudS"); //45
  PImage cloudBig = loadImage("Sprite_CloudB"); //46

    
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
      image(hillBig, posX, posY);
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
