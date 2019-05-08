//Declare images for backgroundTab. Images are assigned in setup.
PImage spriteCoin;
PImage spriteMushroom;

class Collectible{
  float startPosX; //initial horizontal position
  float startScrollAmount; //initial scrollamount
  float totalMovementX = 0; //total pixels moved in the horizontal axis
  float posX; //accurate horizontal position
  float posY; //accurate vertical position
  int frontEndPosX; //rendered horizontal position
  int frontEndPosY; //rendered vertical position
  int identifier; // 0: coin 1: mushroom
  float baseSpeed = 1; //multiplier for updating the horisontal position - used to change direction
  float velocityX; //multiplier for updating the horizontal position
  float velocityY; //multiplier for updating the vertical position
  int collectibleWidth = 32; //collision width
  int collectibleHeight = 32; //collision height
  boolean dead = false; //Determines wheather if a specific instance of the class has been "collected" by mario
  boolean spawnedFromBlock; //Bool used to differentiate between collectibles which were spawned from blocks vs. spawned directly into the level
  int spawnFrame; //the frame at which the instance was spawned (used for showing the coin for only a specific amount of time)
  
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
        case 18: //Coin
          if(spawnedFromBlock){
            image(spriteCoin, frontEndPosX, frontEndPosY -20);
            if(spawnFrame + 50 < frameCount) {
              posY -= 500;
            }
          } else {
            image(spriteCoin, frontEndPosX, frontEndPosY);
          }
        break;
        
        case 19: //Mushroom
          image(spriteMushroom, frontEndPosX, frontEndPosY);
        break;
      }
  }
  
  void Movement(){
    switch(identifier){
      case 19: //Mushroom
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
          case 18: //Coin
          coins++;//Add 1 coin to the amount of coins the player has collected.
          score += 100;
          coin.play(); //Play coin sound
          break;
          
          case 19: //Power-up mushroom
          Player.big = true;
          score += 500;
          powerUp.play(); //Play power-up sound
          break;
        }
        totalMovementX = -10000;
     }
  }
}
