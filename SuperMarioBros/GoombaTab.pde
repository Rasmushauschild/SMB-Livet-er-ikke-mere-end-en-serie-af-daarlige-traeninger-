class Goomba{
  float posX;
  float posY;
  float VelocityX;
  int animCount;
  PImage spriteSheetGoomba;
  PImage[] spritesGoomba = new PImage[2]; //Creates an empty PImage array with the correct length
  int animMode;
  int currentFrame;
  boolean facingRight=true;
  
  
  Goomba(float tempX, float tempY){
    posX = tempX;
    posY = tempY;
  }
  
    void animationSetup(){
    animCount = 2;
    spriteSheetGoomba = loadImage("SpriteSheet_Goomba.png"); //Loads the spritesheet
    
    int W = spriteSheetGoomba.width/animCount;
    
    for(int i = 0; i<spritesGoomba.length; i++){
    int x = i%animCount*W;
    spritesGoomba[i]=spriteSheetGoomba.get(x,0,W,spriteSheetGoomba.height);
    }
  }
  
  void Display(){ 
    switch (animMode){
      case 0: //Moving Right/Left
      if(frameCount%10 == 0 && currentFrame == 0) currentFrame = 1;
      else if(frameCount%10 == 0 && currentFrame == 1) currentFrame = 0;
      if (currentFrame == 1) image(spritesGoomba[0], posX, posY);
      else if(currentFrame == 0) {
      pushMatrix();
      scale(-1,1);
      image(spritesGoomba[0], -posX, posY);
      popMatrix();
      }
      break;
      
      case 1: //Standing still Right/Left
      image(spritesGoomba[1], posX, posY);
      break;
    }
  }
  
  void Movement(){
  
  }
  
  void Scroll(){
  posX = posX-Player.velocityX;
  posX = round(posX/2)*2;
  }
}
