class Player{
  float posX; //Players raw xposition in canvas space
  float posY; //Players raw yposition in canvs space
  float playerWidth = 26;
  float playerHeight = 32; 
  float velocityX; //Multiplier to change xposition
  float velocityY; //Multiplier to change yposition
  int frontEndPosX; //Players rendered xposition 
  int frontEndPosY; //Players rendered yposition
  int animMode; //A 1d blendtree responsible for setting the current animation on Player
  int currentFrame; //Players current frame of animation 
  boolean jumpPossible; //Is the player touching the ground
  boolean gravity; //Multiplier for vertical acceleration
  boolean scroll; //Wheather if the screen is currently scrolling
  boolean dead; //Should players code fire
  boolean facingRight = true; //Determines the orientation og players sprites
  boolean big; //Determines players size
  int bigAnimation = 0;
  //Keyboard input controlls
  public boolean rightPressed; 
  public boolean leftPressed;
  public boolean spacePressed;
  
  int animCount; //Number of frames in spritesheet
  PImage spriteSheetMario; //Container for Players spritesheet
  PImage[] spritesMario = new PImage[15]; //Creates an empty PImage array with the correct length

  Player(float tempX,float tempY){ // Sets players initial location
    posX = tempX;
    posY = tempY;
    }
    
  void animationSetup(){
    animCount = 16; //Setting the length of spritesheet
    spriteSheetMario = loadImage("SpriteSheet_Mario.png"); //Loads the spritesheet
    
    int W = spriteSheetMario.width/animCount; //Sets the width W of each frame (sprite) in the spritesheet
    
    for(int i = 0; i<spritesMario.length; i++){ //Actually cuts up the spritesheet into individual frames (sprites)
    int x = i%animCount*W;
    spritesMario[i]=spriteSheetMario.get(x,0,W,spriteSheetMario.height);
    }
  }
    
  void Movement(){
    for (int i = 0; i<LevelSetup.currentTableCellCount; i++){ //Checks whether or not player is touching ground, determines if player can jump
      if (blockInstances[i]!=null){ //Checks if the curent blockinstance exists in the table
        if(frontEndPosX + playerWidth > blockInstances[i].posX && //player right edge past ground left-side
        frontEndPosX < blockInstances[i].posX + 32 && //player left edge past ground right-side
        frontEndPosY+playerHeight == blockInstances[i].posY){ //player top edge past ground bottom 
          jumpPossible = true;
        }
      }
    }  
    
    //UP-DOWN MOVEMENT ------------------------------------------------------
    //Jump
    if(spacePressed && jumpPossible){ //Jump when space is pressed and player is on ground.
      velocityY=-7;
      animMode = 2;
    }
    
    //Increases jump height if space is held in longer
    if(!spacePressed && !jumpPossible && velocityY<0){ //If the player is going upwards, isn't touching ground and isn't pressing space, then increase gravity
      velocityY += 2.8*deltaTime;
    } else if(!jumpPossible && velocityY>0){ //If the player is going downwards and isn't touching ground, increase gravity
      velocityY += 1.0*deltaTime;
    }
    
    //Constant gravity
    velocityY += 0.2*deltaTime;
    
    if(velocityY > 6) velocityY = 6; //Limiting max-fallspeed
    
    
    //LEFT-RIGHT MOVEMENT ---------------------------------------------------
    
    if (rightPressed && !leftPressed){ //Running right
      velocityX += 0.2*deltaTime; //Adjusting velocity based on deltatime
      facingRight = true;
      if(jumpPossible) animMode = 1;
      if (velocityX < 0 && jumpPossible) animMode = 3;
    } else if (leftPressed && !rightPressed){ //Run left
      velocityX -= 0.2*deltaTime;
      facingRight = false;
      if(jumpPossible) animMode = 1;
      if (velocityX > 0 && jumpPossible) animMode = 3;
    } else if(velocityX > 0){ //Stop running right when button isn't held down
      velocityX -= 0.2*deltaTime;
    } else if(velocityX < 0){ //Stop running left when button isn't held down
      velocityX += 0.2*deltaTime;
    }
    
    if(velocityX > 4) velocityX = 4; // Limiting max-runningspeed
    if(velocityX < -4) velocityX = -4;
    if(velocityX > -0.1 && velocityX < 0.1) { // Making sure Player stops completely
    velocityX = 0;
    if(jumpPossible) animMode = 0;
  }
    if(spacePressed && jumpPossible){ //Jump animation when space is pressed and player is on ground.
    animMode = 2;
    }
    jumpPossible = false;
    
    for (int i = 0; i<LevelSetup.currentTableCellCount; i++){ //Creating a "collision-matrix" around The player, so it does not have to check on every single block in the table
      if ((i >= (int(posY)/32+1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32+1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) || 
          (i >= (int(posY)/32-0)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32-0)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) ||
          (i >= (int(posY)/32-1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32-1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) ||
          (i >= (int(posY)/32-2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32-2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) ||
          (i >= (int(posY)/32+2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32+2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount())){
        if (blockInstances[i]!=null){
          if((frontEndPosX + playerWidth + velocityX > blockInstances[i].posX && //player collision right edge past ground left-side
          frontEndPosX + velocityX < blockInstances[i].posX + 32 && //player collision left edge past ground right-side
          frontEndPosY + playerHeight > blockInstances[i].posY && //player collision bottom edge past ground top
          frontEndPosY < blockInstances[i].posY + 32)){ //player collision top edge past ground bottom 
            velocityX = 0;
          }
          if(frontEndPosX + playerWidth > blockInstances[i].posX && //player collision right edge past ground left-side
          frontEndPosX < blockInstances[i].posX + 32 && //player collision left edge past ground right-side
          frontEndPosY + playerHeight + velocityY > blockInstances[i].posY && //player collision bottom edge past ground top
          frontEndPosY + velocityY < blockInstances[i].posY + 32){ //player collision top edge past ground bottom 
            if (velocityY < 0) blockInstances[i].ActivatedBelow(); //Calling the ActivatedBelow fuction on the hit instance
            velocityY = 0;
          }
          if(frontEndPosX + playerWidth > blockInstances[i].posX && //player right edge past ground left-side
          frontEndPosX < blockInstances[i].posX + 32 && //player left edge past ground right-side
          frontEndPosY + playerHeight > blockInstances[i].posY && //player bottom edge past ground top
          frontEndPosY < blockInstances[i].posY + 32){ //player top edge past ground bottom 
            
            if (posY<(blockInstances[i].posY+16)){ //If player clips in the top half, tp to top
              posY = blockInstances[i].posY-playerHeight; 
              println("DOOR STUCK! DOOR STUCK! 1");
            } else if (posY>(blockInstances[i].posY+16)){ //If player clips in the bottom half, to the bottom
              posY = blockInstances[i].posY+32; 
              println("DOOR STUCK! DOOR STUCK! 2");
            }
          }
        }
      }
    }
    
    if(posX+velocityX-playerWidth/2<0) velocityX = 0; // Makes sure player can't pass the left side of the screen.
    
    if(posX>=224 && velocityX>0){ //Starts scrolling the entire level and all its contents if the player reaches the 224th horisontal pixel
      scroll=true;
      scrollAmount += velocityX;
    } else {
      scroll=false;
    }
    
    if (!scroll){ // If the level is not currently scrolling, move the player
      posX += velocityX;
    }
    posY += velocityY;
  }
  
    void Death(){
      dead = true;
      animMode = -1;
      
      
    
    
    }
    
    void Display(){ //FIX MARIO SPRITESHEET - FRAMES NOT CENTERED
    
      if(big) bigAnimation = 10;
      else bigAnimation = 0;
    
      frontEndPosX = round(posX/2)*2; //Snap to grid
      frontEndPosY = round((posY)/2)*2;
      
      switch (animMode){ //A 1d blendtree responsible for controlling the player animations
                  case 0: //Standing still Right/Left
                  if(facingRight){ //If player is facing right, set the default standing sprite
                  image(spritesMario[0 + bigAnimation], frontEndPosX,frontEndPosY-16);
                  } else { //If the player is facing left, mirror the standing sprite using a push matrix
                  pushMatrix();
                  scale(-1,1);
                  image(spritesMario[0 + bigAnimation], -frontEndPosX,frontEndPosY-16);
                  popMatrix();
                  }
                  break;
                  
                  case 1: //Running Right/Left
                  if(facingRight){//If player is facing right, set the default running animation
                  if(frameCount%round(6-velocityX)==0 && currentFrame <3){ //if statement responsible for quickly flipping through the running sprites at a specific rate to create an animation
                  currentFrame++;
                  } else if(frameCount%round(6-velocityX)==0) currentFrame = 1;
                  image(spritesMario[currentFrame], frontEndPosX,frontEndPosY-16);
                  } else {
                  pushMatrix();
                  scale(-1,1);
                  if(frameCount%round(6+velocityX)==0 && currentFrame <3){
                  currentFrame++;
                  } else if(frameCount%round(6+velocityX)==0) currentFrame = 1;
                  image(spritesMario[currentFrame], -frontEndPosX,frontEndPosY-16);
                  popMatrix();
                  }
                  break;
                  
                  case 2: //Jumping Right/Left
                  if(facingRight){
                  image(spritesMario[5 + bigAnimation], frontEndPosX,frontEndPosY-16);
                  } else {
                  pushMatrix();
                  scale(-1,1);
                  image(spritesMario[5 + bigAnimation], -frontEndPosX,frontEndPosY-16);
                  popMatrix();
                  }
                  break;
                  
                  case 3:
                  if(facingRight){
                  image(spritesMario[4 + bigAnimation], frontEndPosX,frontEndPosY-16);
                  } else {
                  pushMatrix();
                  scale(-1,1);
                  image(spritesMario[4 + bigAnimation], -frontEndPosX,frontEndPosY-16);
                  popMatrix();
                  }
                  break;
                  
      }
  }
}

void keyReleased(){
  //println("Key Released");
  if (keyCode == RIGHT) Player.rightPressed = false;
  if (keyCode == LEFT) Player.leftPressed = false;
  if (keyCode == 32) Player.spacePressed = false;
}

void keyPressed(){
  //println("Key Pressed");
  if (keyCode == RIGHT) Player.rightPressed = true;
  if (keyCode == LEFT) Player.leftPressed = true;
  if (keyCode == 32) Player.spacePressed = true;
}
