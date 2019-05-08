class Player{
  float posX; //Players raw xposition in canvas space
  float posY; //Players raw yposition in canvs space
  float playerWidth = 26; //Players default width
  float playerHeight = 31; //Players default heigth (hard coded in Display())
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
  boolean playerActive = true;
  int bigAnimation = 0; //integer value added to the loaded sprite in marioSprites[] to load the proper sprites (7)
  int deathFrame; //integer value set to the frame Mario dies
  int framesSinceDeath; //integer value counting up every frame after Mario has died
  int deathPosY; //the y position for Marios death
  float flagPoleStartX; //the x position for where the flagpole area begins
  boolean flagPoleAction; //boolean set true when Mario reaches the flagpole - used for disabling user input
  
  //Variables related to pipes
  int entryPipeMovement=-1; //0 is down, 1 is right, 2 is up, 3 is left
  int exitPipeMovement= -1; //0 is down, 1 is right, 2 is up, 3 is left
  int pipeAction; //0 is inactive pipe animation, 1 is an active entry pipe animation and -1 is an active exit pipe animation
  float pipeDestinationScrollAmount; //the amount the world must scroll for the new pipe location
  float pipeDestinationY; //the vertical position to spawn Mario at
  float pipeStartY; //the vertical position at which Mario enters the pipe
  float pipeStartX; //the horizontal position at which Mario enters the pipe
  
  //Keyboard input controls
  public boolean rightPressed;
  public boolean leftPressed;
  public boolean spacePressed;
  public boolean downPressed;
  public boolean upPressed;
  
  int animCount; //Number of frames in spritesheet
  PImage spriteSheetMario; //Container for Players spritesheet
  PImage[] spritesMario = new PImage[16]; //Creates an empty PImage array with the correct length

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
  
  void PlayerActive(){
   if(playerActive){
    if(pipeAction == 0 && !dead && !flagPoleAction){
  Movement();
    }
    Display();
   }
  }
    
  void Movement(){
    if(posY > 448) Death();
    
    for (int i = 0; i<LevelSetup.currentTableCellCount; i++){ //Checks whether or not player is touching ground, determines if player can jump
      if (blockInstances[i]!=null){ //Checks if the curent blockinstance exists in the table
        if(frontEndPosX + playerWidth > blockInstances[i].posX && //player right edge past ground left-side
        frontEndPosX < blockInstances[i].posX + 32){ //player left edge past ground right-side'
          if (big){
            if(frontEndPosY+playerHeight-32 == blockInstances[i].posY)
            jumpPossible = true;
          } else if(frontEndPosY+playerHeight == blockInstances[i].posY){
            jumpPossible = true;
          }
        }
      }
    }  
    
    //UP-DOWN MOVEMENT ------------------------------------------------------
    //Jump
    if((spacePressed||upPressed) && jumpPossible){ //Jump when space is pressed and player is on ground.
      velocityY=-7;
      animMode = 2;
    }
    
    //Increases jump height if space is held in longer
    if(!(spacePressed||upPressed) && !jumpPossible && velocityY<0){ //If the player is going upwards, isn't touching ground and isn't pressing space, then increase gravity
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
    if((spacePressed||upPressed) && jumpPossible){ //Jump animation and sound when space is pressed and player is on ground.
      jump.play();
      animMode = 2;
    }
    jumpPossible = false; //Reset jumpPossible every frame.
    
    for (int i = 0; i<LevelSetup.currentTableCellCount; i++){ //Creating a "collision-matrix" around The player, so it does not have to check on every single block in the table
      if ((i >= (int(posY)/32+1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32+1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) || 
          (i >= (int(posY)/32-0)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32-0)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) ||
          (i >= (int(posY)/32-1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32-1)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) ||
          (i >= (int(posY)/32-2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32-2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount()) ||
          (i >= (int(posY)/32+2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32)-1)%LevelSetup.currentLevelTable.getColumnCount() && i <= (int(posY)/32+2)*LevelSetup.currentLevelTable.getColumnCount()+((int(posX + scrollAmount)/32+1))%LevelSetup.currentLevelTable.getColumnCount())){
        if (blockInstances[i]!=null && blockInstances[i].identifier!=10){
          if(posX + playerWidth > blockInstances[i].posX && //player right edge past ground left-side
          posX < blockInstances[i].posX + 31 && //player left edge past ground right-side
          posY + playerHeight > blockInstances[i].posY && //player bottom edge past ground top
          posY < blockInstances[i].posY + 31){ //player top edge past ground bottom 
            if (posY<(blockInstances[i].posY+16)){ //If player clips in the top half, tp to top
              posY = blockInstances[i].posY-playerHeight; 
            } else if (posY>(blockInstances[i].posY+16)){ //If player clips in the bottom half, to the bottom
              posY = blockInstances[i].posY+playerHeight; 
            }
          }
          if((posX + playerWidth + velocityX > blockInstances[i].posX && //player collision right edge past ground left-side
          posX + velocityX < blockInstances[i].posX + 31 && //player collision left edge past ground right-side
          posY + playerHeight > blockInstances[i].posY && //player collision bottom edge past ground top
          posY < blockInstances[i].posY + 31)){ //player collision top edge past ground bottom 
            if (rightPressed || leftPressed) blockInstances[i].ActivatedHorizontalPipe(); 
            velocityX = 0;            
          }
          if(posX + playerWidth > blockInstances[i].posX && //player collision right edge past ground left-side
          posX < blockInstances[i].posX + 31 && //player collision left edge past ground right-side
          posY + playerHeight + velocityY > blockInstances[i].posY && //player collision bottom edge past ground top
          posY + velocityY < blockInstances[i].posY + 31){ //player collision top edge past ground bottom 
            if (velocityY < 0) blockInstances[i].ActivatedBelow(); //Calling the ActivatedBelow fuction on the hit instance
            if (downPressed || upPressed) blockInstances[i].ActivatedVerticalPipe(); //If down-button is pressed on top of pipe, go down pipe.            
            velocityY = 0;

          }
          
        }
      }
    }
    
    if(posX+velocityX-playerWidth/2<0) velocityX = 0; // Makes sure player can't pass the left side of the screen.
    
    if(posX>=224 && velocityX>0){ //Starts scrolling the entire level and all its contents if the player reaches the 224th horizontal pixel
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
  
    void Death(){ //Called upon Marios death
      if(!dead){
        pauseMusic(); 
        death.play();
        big = false;
        dead = true;
        deathFrame = frameCount;
        deathPosY = frontEndPosY;
        
      }
    }
    
    void Display(){     
      frontEndPosX = round(posX/2)*2; //Snap to grid
      frontEndPosY = round(posY/2)*2;
      
      //rect(posX,posY,playerWidth,playerHeight);
      
      
      if(dead){
        framesSinceDeath = frameCount - deathFrame;
        animMode = -1;
      }
      
      if(pipeAction != 0){
        animMode = 4; //Sets the proper animMode for entereing and leaving pipes
      }
      
      if(big){ //Called when a mushroom is obtained
        bigAnimation = 7; //skips the first 7 frames in marioSprites[] to set big Mario sprites
        playerHeight = 64; //sets a new proportionally accurate playerheight to fit big Mario
        frontEndPosY = round((posY/2)*2+32); //adds 32 pixels to the player vertical position, to compensate for the larger sprite
      }else{
        bigAnimation = 0; //starts the animtion of marioSprites[] at index [0]
        playerHeight = 32; //sets proportionally accurate height to small Mario
      }
      
      switch (animMode){ //A 1d blendtree responsible for controlling the player animations
        case -1:
        image(spritesMario[15], frontEndPosX,frontEndPosY + ( pow(framesSinceDeath*4, 2) * pow(10, -2.5) - framesSinceDeath*4));
        if((frontEndPosY + ( pow(framesSinceDeath*4, 2) * pow(10, -2.5) - framesSinceDeath*4)) > 500){
          livesLeft--;
          if (livesLeft < 0) loadMainMenu(); //If Mario has no lives left, reset the game
          if (livesLeft >= 0) loadCurrentScene(); //If Mario has lives left, respawn him into the same level.
        }
        
        break;
      
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
        image(spritesMario[currentFrame + bigAnimation], frontEndPosX,frontEndPosY-16);
        } else {
        pushMatrix();
        scale(-1,1);
        if(frameCount%round(6+velocityX)==0 && currentFrame <3){
        currentFrame++;
        } else if(frameCount%round(6+velocityX)==0) currentFrame = 1;
        image(spritesMario[currentFrame + bigAnimation], -frontEndPosX,frontEndPosY-16);
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
        
        case 4:
        if (pipeAction == 1){ //Entry pipe movement.
          switch (entryPipeMovement){
            case 0:
            if (posY < pipeStartY + playerHeight){ posY++;
            } else {pipeAction = 2;}
            break;
            case 1:
            if (posX < pipeStartX + playerWidth){ posX++;
            } else {pipeAction = 2;}
            break;
            case 2:
            if (posY > pipeStartY - playerHeight){ posY--;
            } else {pipeAction = 2;}
            case 3:
            if (posX > pipeStartX - playerWidth){ posX--;
            } else {pipeAction = 2;}
            break;
          }
        }
        
        //Teleport player once entry pipe movement is finished and moves onto the exit pipe movement by setting pipeAction = -1
        if (pipeAction == 2){
          posY = pipeDestinationY; 
          scrollAmount = pipeDestinationScrollAmount;
          pipeStartY = posY; //Update pipeStartY to fit with exit pipe
          pipeStartX = posX; //Update pipeStartX to fit with exit pipe
          pipeAction = -1; //Move on to exit pipe movement
          if (currentPalette == 0 && LevelSetup.currentLevel!=2){
            loadSprites(1);
          } else if (currentPalette == 1 && LevelSetup.currentLevel!=2){
            loadSprites(0);
          }
          
        }
        
        if (pipeAction == -1){
          switch (exitPipeMovement){
            
            case 0:
            if (posY < pipeStartY + playerHeight){ posY++;
            } else {pipeAction = 0;}
            break;
            case 1:
            if (posX < pipeStartX + playerWidth){ posX++;
            } else {pipeAction = 0;}
            break;
            case 2:
            if (posY > pipeStartY - playerHeight){ posY--;
            } else {pipeAction = 0;}
            break;
            case 3:
            if (posX > pipeStartX - playerWidth){ posX--;
            } else {pipeAction = 0;}
            break;
          }
        }
        
        if(facingRight){ //If player is facing right, set the default standing sprite
        image(spritesMario[0 + bigAnimation], frontEndPosX,frontEndPosY-16);
        } else { //If the player is facing left, mirror the standing sprite using a push matrix
        pushMatrix();
        scale(-1,1);
        image(spritesMario[0 + bigAnimation], -frontEndPosX,frontEndPosY-16);
        popMatrix();
        }
        break;
        
        case 5: // Animation for mario sliding down the flagpole
        if (posY < 310){ //Slides Mario down
          posY+=2;
          if (big){ //Sets the sprite based on Marios size
            image(spritesMario[13], frontEndPosX, frontEndPosY);
            } else image(spritesMario[6], frontEndPosX, frontEndPosY);
        } else {
              posX +=2; //Moves Mario horizontally towards the castle
              posY = 352;
              if(frameCount%5==0 && currentFrame <3){ //if statement responsible for quickly flipping through the running sprites at a specific rate to create an animation
                currentFrame++;
              } else if(frameCount%5==0) currentFrame = 1;
              if (big){
                image(spritesMario[currentFrame + bigAnimation], frontEndPosX,frontEndPosY-16);
              } else image(spritesMario[currentFrame + bigAnimation], frontEndPosX,frontEndPosY+16);
            }
            if (posX > flagPoleStartX + 140){
             loadNextScene(); //If Mario reaches the end of the current level, load the next level
            }
        break;
      }
  }
}

void keyReleased(){ // Responsible for receiving key inputs
  if(gameState == 2){
    if(keyCode == RIGHT) Player.rightPressed = false;
    if(keyCode == LEFT) Player.leftPressed = false;
    if(keyCode == DOWN) Player.downPressed = false;
    if(keyCode == UP) Player.upPressed = false;
    if(keyCode == 32) Player.spacePressed = false;
  } else if (gameState == 0 && keyCode == ENTER && LevelSetup.currentLevel==0){
    loadNextScene();
  }
}

void keyPressed(){ // Responsible for receiving key inputs
  if(gameState == 2){
    if(keyCode == RIGHT) Player.rightPressed = true;
    if(keyCode == LEFT) Player.leftPressed = true;
    if(keyCode == DOWN) Player.downPressed = true;
    if(keyCode == UP) Player.upPressed = true;
    if(keyCode == 32) Player.spacePressed = true;
  }
}
