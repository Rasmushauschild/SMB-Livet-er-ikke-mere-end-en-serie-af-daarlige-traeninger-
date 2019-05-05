class Goomba{
  float startPosX;
  float totalMovementX;
  float posX;
  float posY;
  int frontEndPosX;
  int frontEndPosY;
  float baseSpeed = -1;
  float velocityX;
  float velocityY;
  int frameCountSinceDeath;
  int goombaWidth = 32;
  int goombaHeight = 32;
  boolean dead;
  
  int animCount;
  PImage spriteSheetGoomba;
  PImage[] spritesGoomba = new PImage[2]; //Creates an empty PImage array with the correct length
  int animMode;
  int currentFrame;
  
  boolean facingRight=true;
  
  Goomba(float tempX, float tempY){
    startPosX = tempX;
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
  
  void Alive(){ //Main Function for the Goomba: Calls all other functions. 
    posX = startPosX - scrollAmount + totalMovementX; //Makes the Goombas scroll with the player, no matter whether they are active or not.

    if((posX - Player.posX)/32 < 16 && (posX - Player.posX)/32 > -8){ //The Gomba is only active when in view of the player.
      if(!dead) Movement(); //Movement shouldn't happen when the Goomba is in its "corpse" state
      Display();
      CheckForDeath();
    }
  }
  
  void Display(){
    //Snap to grid
    frontEndPosX = round(posX/2)*2;
    frontEndPosY = round(posY/2)*2;
    
    switch (animMode){
        case 0: //Moving Right/Left
        if(frameCount%10 == 0 && currentFrame == 0) currentFrame = 1;
        else if(frameCount%10 == 0 && currentFrame == 1) currentFrame = 0;
        if (currentFrame == 1) image(spritesGoomba[0], frontEndPosX, frontEndPosY);
        else if(currentFrame == 0) {
        pushMatrix();
        scale(-1,1);
        image(spritesGoomba[0], -frontEndPosX, frontEndPosY);
        popMatrix();
        }
        break;
        
        case 1: //Standing still Right/Left
        image(spritesGoomba[1], frontEndPosX, frontEndPosY);
        break;
      }
  }
  
  void Movement(){
    velocityX = baseSpeed * deltaTime;
    velocityY += 0.2 * deltaTime;
    
    for (int i = 0; i<LevelSetup.currentTableCellCount; i++){
      if ((i >= (int(posY)/32+1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32+1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) || 
          (i >= (int(posY)/32-0)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32-0)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) ||
          (i >= (int(posY)/32-1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32-1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) ||
          (i >= (int(posY)/32-2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32-2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) ||
          (i >= (int(posY)/32+2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32+2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount())){
        if (blockInstances[i]!=null){
          if((posX + goombaWidth + velocityX > blockInstances[i].posX && //player right edge past ground left-side
          posX + velocityX < blockInstances[i].posX + 32 && //player left edge past ground right-side
          posY + goombaHeight > blockInstances[i].posY && //player bottom edge past ground top
          posY < blockInstances[i].posY + 32)){
            velocityX *= -1;
            baseSpeed *= -1;
          }
          if(posX + goombaWidth > blockInstances[i].posX && //player right edge past ground left-side
          posX < blockInstances[i].posX + 32 && //player left edge past ground right-side
          posY + goombaHeight + velocityY > blockInstances[i].posY && //player bottom edge past ground top
          posY + velocityY < blockInstances[i].posY + 32){ //player top edge past ground bottom 
            velocityY = 0;
          }
          if(posX + goombaWidth > blockInstances[i].posX && //player right edge past ground left-side
          posX < blockInstances[i].posX + 32 && //player left edge past ground right-side
          posY + goombaHeight > blockInstances[i].posY && //player bottom edge past ground top
          posY < blockInstances[i].posY + 32){ //player top edge past ground bottom 
            
            if(posX<(blockInstances[i].posX+16)){ //If Goomba clips in left half, teleport to left-side
              posX = blockInstances[i].posX-goombaWidth; 
              println("GOMBA STUCK! 1");
            } else if (posX>(blockInstances[i].posX+16)){ //If Goomba clips in right half, teleport to right-side
              posX = blockInstances[i].posX+32; 
              println("GOMBA STUCK! 2");
            }
          }
        }
      }
    }
    
    totalMovementX += velocityX; //Rather than adding velocity to posX, it's added to a value which tracks the total X movement of the Goomba. This allows the Gombas position to act like a block, but simply with a small offset due to its movement.
    posY += velocityY;
    

  }
  void CheckForDeath(){
    
    //Check if the player has killed the Goomba and the Goomba is still alive. If true, play death animation.
    if(frontEndPosX + goombaWidth > Player.frontEndPosX && 
    frontEndPosX < Player.frontEndPosX + 32 && 
    frontEndPosY + goombaHeight-10 > Player.frontEndPosY && 
    frontEndPosY < Player.frontEndPosY + 32 && Player.velocityY > 0 &&
    !dead){
      dead = true;
      animMode = 1;
      frameCountSinceDeath = frameCount;
      Player.velocityY = -12;
      Player.animMode = 2;

    //Checks if the player has been killed by the Goomba
    } else if(frontEndPosX + goombaWidth > Player.frontEndPosX && 
    frontEndPosX < Player.frontEndPosX + 32 && 
    frontEndPosY + goombaHeight > Player.frontEndPosY && 
    frontEndPosY < Player.frontEndPosY + 32 && !dead){
      println("Mario Killed" + frameCount);
      Player.Death();
    }
    
    //After the Goomba has been dead for 50 frames, tp it away so that it becomes inactive.
    if(frameCount - 50 > frameCountSinceDeath && dead){
      totalMovementX = -10000;
    }
  }
}
