class Collectible{
  float startPosX;
  float startScrollAmount;
  float totalMovementX = 0;
  float posX;
  float posY;
  int frontEndPosX;
  int frontEndPosY;
  int identifier; // 0: coin 1: mushroom
  float baseSpeed = 1;
  float velocityX;
  float velocityY;
  float deathTime;
  int collectibleWidth = 32;
  int collectibleHeight = 32;
  boolean dead = false;
  boolean spawnedFromBlock = true;
  int spawnFrame;
  
  int animCount = 2;
  PImage spriteSheetCollectibles;
  PImage[] spritesCollectibles = new PImage[animCount]; //Creates an empty PImage array with the correct length
  int animMode = 1;
  
  Collectible(float tempX, float tempY, int tempIdentifier){
    startPosX = tempX;
    posX = tempX;
    posY = tempY;
    identifier = tempIdentifier;
    startScrollAmount = scrollAmount;
  }
  
  
  void Alive(){ //Main Function for the collectible: Calls all other functions. 
    posX = startPosX - scrollAmount + startScrollAmount + totalMovementX; //Makes the collectibles scroll with the player, no matter whether they are active or not. A start scroll amount value is required, as the mushroom can be spawned after the screen has already been scrolled a bit.

    if((posX - Player.posX)/32 < 16 && (posX - Player.posX)/32 > -8){ //The collectible is only active when in view of the player.
      Movement(); //Movement shouldn't happen when the Goomba is in its "corpse" state
      Display();
      CheckForHit();
    }
  }
  
  void Display(){
    frontEndPosX = round(posX/2)*2;
    frontEndPosY = round(posY/2)*2;
    
    switch (identifier){
        case 18: //Standing still Right/Left
          if(spawnedFromBlock){
            image(spritesCollectibles[1], frontEndPosX, frontEndPosY -20);
            if(spawnFrame + 30 < frameCount) {
              posY -= 500;
            }
          } else image(spritesCollectibles[1], frontEndPosX, frontEndPosY);
        break;
        
        case 19: //Coin
          image(spritesCollectibles[0], frontEndPosX, frontEndPosY);
        break;
      }
  }
  
  void Movement(){
    switch(identifier){
      case 1:
    velocityX = baseSpeed * deltaTime;
    velocityY += 0.2 * deltaTime;
    
    for (int i = 0; i<LevelSetup.currentTableCellCount; i++){
      if ((i >= (int(posY)/32+1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32+1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) || 
          (i >= (int(posY)/32-0)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32-0)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) ||
          (i >= (int(posY)/32-1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32-1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) ||
          (i >= (int(posY)/32-2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32-2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) ||
          (i >= (int(posY)/32+2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32+2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount())){
        if (blockInstances[i]!=null){
          if((posX + collectibleWidth + velocityX > blockInstances[i].posX && //player right edge past ground left-side
            posX + velocityX < blockInstances[i].posX + 32 && //player left edge past ground right-side
            posY + collectibleHeight > blockInstances[i].posY && //player bottom edge past ground top
            posY < blockInstances[i].posY + 32)){
              velocityX *= -1;
              baseSpeed *= -1;
          }
            if(posX + collectibleWidth > blockInstances[i].posX && //player right edge past ground left-side
            posX < blockInstances[i].posX + 32 && //player left edge past ground right-side
            posY + collectibleHeight + velocityY > blockInstances[i].posY && //player bottom edge past ground top
            posY + velocityY < blockInstances[i].posY + 32){ //player top edge past ground bottom 
              velocityY = 0;
            }
            if(posX + collectibleWidth > blockInstances[i].posX && //player right edge past ground left-side
            posX < blockInstances[i].posX + 32 && //player left edge past ground right-side
            posY + collectibleHeight > blockInstances[i].posY && //player bottom edge past ground top
            posY < blockInstances[i].posY + 32){ //player top edge past ground bottom 
            
            if(posX<(blockInstances[i].posX+16)){ //If Goomba clips in left half, teleport to left-side
              posX = blockInstances[i].posX-collectibleWidth; 
                println("GOMBA STUCK! 1");
            } else if (posX>(blockInstances[i].posX+16)){ //If Goomba clips in right half, teleport to right-side
                posX = blockInstances[i].posX+32; 
                println("GOMBA STUCK! 2");
              }
            }
          }
        }
      }
    
    totalMovementX += velocityX;
    posY += velocityY;
    break;
    }
  }
  void CheckForHit(){
    if(frontEndPosX + collectibleWidth > Player.frontEndPosX && //player right edge past ground left-side
      frontEndPosX < Player.frontEndPosX + 32 && //player left edge past ground right-side
      frontEndPosY + collectibleHeight > Player.frontEndPosY && //player bottom edge past ground top
      frontEndPosY < Player.frontEndPosY + 32){
        
        switch(identifier){
          case 0: //Coin
          coins++;//Add 1 coin to the amount of coins the player has collected.
          score += 100;
          coin.play(); //Play coin sound
          break;
          
          case 1: //Power-up mushroom
          Player.big = true;
          score += 500;
          powerUp.play(); //Play power-up sound
          break;
        }
        totalMovementX = -10000;
     }
  }
}
