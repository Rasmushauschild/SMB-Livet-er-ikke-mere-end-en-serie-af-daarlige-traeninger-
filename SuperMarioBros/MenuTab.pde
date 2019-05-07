PImage coinCounter;
PImage cross;

class Menu{
  int posX;
  int posY;
  int identifier;
  PImage titlecard = loadImage("Sprite_Titlecard.png");
  
  
  Menu(int tempX, int tempY, int tempIdentifier){
    posX = tempX;
    posY = tempY;
    identifier = tempIdentifier;
  }
  
  void Active(){
    Display();
  }
  
  void Display(){
    
    switch(identifier){
      case 30: //The text displayed in the top of the screen.
      text("Mario               World  Time",posX,posY);
      
      break; 
      case 31: //Score text
      text(score,posX,posY-15);
      break;
      
      case 33: //World-Level text
      levelInWorld = ((LevelSetup.currentLevel-1)%4)+1; //There are 4 level pr. world. Automatically calculates the current world level based on current level overall.
      
      text(world + "-" + levelInWorld,posX+6,posY-15);
      break;
      
      case 34: //Time left in level text
      text(timeLeft,posX,posY-15);
      break;
      
      case 35: //Titlecard
      imageMode(CORNER);
      image(titlecard, posX, posY);
      imageMode(CENTER);
      break;
      
      case 36: //Prompt to start on titlescreen
      text("Press Enter To Start",posX,posY);
      break;
      
      case 37: //Coins text
      image(coinCounter,posX-50,posY-22);
      text(coins,posX-30,posY-15);
      break;
      
      case 38:
      text("world " + world,posX-40+15,posY);
      image(Player.spritesMario[0], posX-20+15,posY+16);
      image(cross, posX+10+15, posY+30);
      text(livesLeft, posX+35+15,posY+37);
      break;
    
    }
  }
  
}
