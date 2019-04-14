class Block{
    float posX;
    float posY;
    int identifier;
    PImage img = loadImage("Sprite_Brick.png");
     
    Block(float tempX, float tempY, int tempIdentifier){
      posX = tempX;
      posY = tempY;
      identifier = tempIdentifier;
      
    }
    
    void Display(){
      switch (identifier){
        case 2: //Ground Block
        image(img, posX, posY);
        break;
      }
      
      
      
    }
    
    void Scroll(){
      posX = posX-Player.velocityX;
      posX = round(posX/2)*2;
    }
    
}
