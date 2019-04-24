class Block{
    float posX;
    float posY;
    float sizeX;
    float sizeY;
    int identifier;
    PImage groundSprite = loadImage("Sprite_Ground.png");
    PImage itemSprite = loadImage("Sprite_Item.png");
    PImage brickSprite = loadImage("Sprite_Brick.png");
    PImage goombaSprite = loadImage("Sprite_Goomba.png");
    PImage pipe = loadImage("Sprite_Pipe.png");
    PImage pipeTop = loadImage("Sprite_PipeTop.png");
     
    Block(float tempX, float tempY, int tempIdentifier){
      posX = tempX;
      posY = tempY;
      identifier = tempIdentifier;
      
    }
    
    void Display(){
      switch (identifier){
        case 2: //Ground Block
        image(groundSprite, posX, posY);
        break;
        
        case 3:
        image(brickSprite, posX, posY);
        break;
        
        case 4: //Item Block
        image(itemSprite, posX, posY);
        break;
        
        case 5:
        image(pipe, posX, posY);
        break;
        
        case 6:
        image(pipeTop, posX, posY);
        break;
        
        case 20:
        image(goombaSprite, posX, posY);
        break;
      }
      
      
      
    }
    
    void Scroll(){
      posX = posX-Player.velocityX;
      posX = round(posX/2)*2;
    }
    
}
