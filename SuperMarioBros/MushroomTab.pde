class Mushroom{
  float startPosX;
  float startScrollAmount;
  float totalMovementX = 0;
  float posX;
  float posY;
  int frontEndPosX;
  int frontEndPosY;
  float baseSpeed = 1;
  float velocityX;
  float velocityY;
  float deathTime;
  int mushroomWidth = 32;
  int mushroomHeight = 32;
  boolean dead = false;
  
  int animCount = 2;
  PImage spriteSheetMushroom;
  PImage[] spritesMushroom = new PImage[animCount]; //Creates an empty PImage array with the correct length
  int animMode;
  
  Mushroom(float tempX, float tempY){
    startPosX = tempX;
    posX = tempX;
    posY = tempY;
    startScrollAmount = scrollAmount;
  }
  
  void animationSetup(){
    spriteSheetMushroom = loadImage("SpriteSheet_Mushroom.png"); //Loads the spritesheet
    
    int W = spriteSheetMushroom.width/animCount;
    
    for(int i = 0; i<spritesMushroom.length; i++){
    int x = i%animCount*W;
    spritesMushroom[i]=spriteSheetMushroom.get(x,0,W,spriteSheetMushroom.height);
    }
}
  
  void Alive(){ //Main Function for the Mushroom: Calls all other functions. 
    posX = startPosX - scrollAmount + startScrollAmount + totalMovementX; //Makes the Goombas scroll with the player, no matter whether they are active or not. A start scroll amount value is required, as the mushroom can be spawned after the screen has already been scrolled a bit.

    if((posX - Player.posX)/32 < 16 && (posX - Player.posX)/32 > -8){ //The Gomba is only active when in view of the player.
      Movement(); //Movement shouldn't happen when the Goomba is in its "corpse" state
      Display();
      CheckForHit();
      println(posX);
    }
  }
  
  void Display(){
    frontEndPosX = round(posX/2)*2;
    frontEndPosY = round(posY/2)*2;
    
    switch (animMode){
        case 0: //Moving Right/Left
        image(spritesMushroom[0], frontEndPosX, frontEndPosY);
        break;
        
        case 1: //Standing still Right/Left
        image(spritesMushroom[1], frontEndPosX, frontEndPosY);
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
          if((posX + mushroomWidth + velocityX > blockInstances[i].posX && //player right edge past ground left-side
          posX + velocityX < blockInstances[i].posX + 32 && //player left edge past ground right-side
          posY + mushroomHeight > blockInstances[i].posY && //player bottom edge past ground top
          posY < blockInstances[i].posY + 32)){
            velocityX *= -1;
            baseSpeed *= -1;
          }
          if(posX + mushroomWidth > blockInstances[i].posX && //player right edge past ground left-side
          posX < blockInstances[i].posX + 32 && //player left edge past ground right-side
          posY + mushroomHeight + velocityY > blockInstances[i].posY && //player bottom edge past ground top
          posY + velocityY < blockInstances[i].posY + 32){ //player top edge past ground bottom 
            velocityY = 0;
          }
          if(posX + mushroomWidth > blockInstances[i].posX && //player right edge past ground left-side
          posX < blockInstances[i].posX + 32 && //player left edge past ground right-side
          posY + mushroomHeight > blockInstances[i].posY && //player bottom edge past ground top
          posY < blockInstances[i].posY + 32){ //player top edge past ground bottom 
            
            if(posY<(blockInstances[i].posY+16)){ //If Mario clips in the top half, tp to top
              posY = blockInstances[i].posY-mushroomHeight; 
              println("DOOR STUCK! DOOR STUCK! 1");
            } else if (posY>(blockInstances[i].posY+16)){ //If Mario clips in the bottom half, tp to the bottom
              posY = blockInstances[i].posY+32; 
              println("DOOR STUCK! DOOR STUCK! 2");
            }
          }
        }
      }
    }
    
    totalMovementX += velocityX;
    posY += velocityY;
    
  }
  void CheckForHit(){
    if(frontEndPosX + mushroomWidth > Player.frontEndPosX && //player right edge past ground left-side
    frontEndPosX < Player.frontEndPosX + 32 && //player left edge past ground right-side
    frontEndPosY + mushroomHeight > Player.frontEndPosY && //player bottom edge past ground top
    frontEndPosY < Player.frontEndPosY + 32){
      println("ELLO!");
    Player.big = true;
    totalMovementX = -10000;
    }
  }
}
