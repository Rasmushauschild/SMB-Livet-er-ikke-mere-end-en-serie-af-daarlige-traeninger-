class Goomba{
  float posX;
  float posY;
  int animCount;
  PImage spriteSheetGoomba;
  PImage[] spritesGoomba = new PImage[13]; //Creates an empty PImage array with the correct length
  
  
  Goomba(float tempX, float tempY){
    posX = tempX;
    posY = tempY;
  }
  
    void animationSetup(){
    animCount = 3;
    spriteSheetGoomba = loadImage("SpriteSheet_Goomba.png"); //Loads the spritesheet
    
    int W = spriteSheetGoomba.width/animCount;
    
    for(int i = 0; i<spritesGoomba.length; i++){
    int x = i%animCount*W;
    spritesGoomba[i]=spriteSheetGoomba.get(x,0,W,spriteSheetGoomba.height);
    }
  }
  
}
