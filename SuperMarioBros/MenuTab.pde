class Menu{
  int posX;
  int posY;
  int identifier;
  int timeLeft = 400;
  int world = 1;
  int levelInWorld = 1;
  int score;
  PImage textMarioWorldTime = loadImage("UITopElement.png");
  PImage titlecard = loadImage("Sprite_Titlecard.png");
  
  
  Menu(int tempX, int tempY, int tempIdentifier){
    posX = tempX;
    posY = tempY;
    identifier = tempIdentifier;
  }
  
  void Alive(){
    Display();
  }
  
  void Display(){
    
    switch(identifier){
      case 30: //The text displayed in the top of the screen.
      text("Mario               World  Time",posX,posY);
      
      break;
      case 31:
      text(score,posX,posY-15);
      break;
      
      case 33:
      text(world + "-" + levelInWorld,posX+34,posY-15);
      break;
      
      case 34:
      text(timeLeft,posX,posY-15);
      break;
      
      case 35:
      imageMode(CORNER);
      image(titlecard, posX, posY);
      imageMode(CENTER);
      break;
      
      case 36:
      text("Press Enter To Start",posX,posY);
      break;
      
    
    }
  }
  
}
