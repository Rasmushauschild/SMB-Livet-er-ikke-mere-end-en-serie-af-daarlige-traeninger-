class Background{
  int posX;
  int posY;
  int identifier;
  
  PImage bushSmall = loadImage("Sprite_BushS");
  PImage bushMedium = loadImage("Sprite_BushM");
  PImage bushBig = loadImage("Sprite_BushL");
  PImage hillSmall = loadImage("Sprite_HillS");
  PImage hillBig = loadImage("Sprite_HillB");
  PImage cloudSmall = loadImage("Sprite_CloudS");
  PImage cloudBig = loadImage("Sprite_CloudB");

    
  Background(int tempX, int tempY, int tempIdentifier){
    posX = tempX;
    posY = tempY;
    identifier = tempIdentifier;
    
  }
  void Display(){
    posX = startPosX-scrollAmount;
    
    switch (identifier){
      case 41: //Small Bush
      image(bushSmall, posX, posY);
      break;
      
      case 42: //Medium Bush
      image(bushMedium, posX, posY);
      break;
      
      case 43: //Big Bush
      image(bushBig, posX, posY);
      break;
      
      case 44: //small Hill
      image(hillSmall, posX, posY);
      break;
      
      case 45: //Big Hill
      image(hillBig, posX, posY);
      break;
      
      case 45: //Small Cloud
      image(cloudSmall, posX, posY);
      break;
      
      case 45: //Big Cloud
      image(cloudBig, posX, posY);
      break;
  }
    
}
