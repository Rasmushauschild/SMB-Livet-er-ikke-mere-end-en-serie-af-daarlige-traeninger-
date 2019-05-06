class Menu{
  int posX;
  int posY;
  int identifier;
  PImage textMarioWorldTime = loadImage("UITopElement.png");
  
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
        Background.Display(#AED1EE);
        image(textMarioWorldTime, posX, posY);
      break;
    
    }
  }
  
}
