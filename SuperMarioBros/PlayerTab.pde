class Player{
  float posX;
  float posY;
  float playerWidth = 26;
  float playerHeight = 32;
  float velocityX;
  float velocityY;
  float frontEndPosX;
  float frontEndPosY;
  int animMode;
  int currentFrame;
  boolean jumpPossible;
  boolean gravity;
  boolean scroll;
  boolean rightLeft;
  public boolean rightPressed;
  public boolean leftPressed;
  public boolean spacePressed;

  Player(float tempX,float tempY){
    posX = tempX;
    posY = tempY;
    }
    
  void Movement(){
    //Resets animMode
    for (int i = 0; i<LevelSetup.currentTableCellCount; i++){ //Checks whether or not player is touching ground, determines if player can jump
      if (groundInstances[i]!=null){
        if(frontEndPosX + playerWidth > groundInstances[i].posX && //player right edge past ground left-side
        frontEndPosX < groundInstances[i].posX + 32 && //player left edge past ground right-side
        frontEndPosY+playerHeight == groundInstances[i].posY){ //player top edge past ground bottom 
          jumpPossible = true;
        }
      }
    }  
    
    //UP-DOWN MOVEMENT ------------------------------------------------------
    //Jump
    if(spacePressed && jumpPossible){ //Jump when space is pressed and player is on ground.
      velocityY=-6;
    }
    
    //Increases jump height if space is held in longer
    if(!spacePressed && !jumpPossible && velocityY<0){ //If the player is going upwards, isn't touching ground and isn't pressing space, then increase gravity
      velocityY += 0.2*deltaTime;
    } else if(!jumpPossible && velocityY>0){ //If the player is going downwards and isn't touching ground, increase gravity
      velocityY += 0.2*deltaTime;
    }
    
    
    //Gravity
    velocityY += 0.2*deltaTime;
    
    
    if(velocityY > 6) velocityY = 6; //Max-fallspeed
    
    
    //LEFT-RIGHT MOVEMENT ---------------------------------------------------
    
    if (rightPressed && !leftPressed){ //Run right
      velocityX += 0.2*deltaTime;
      rightLeft = false;
      if(jumpPossible) animMode = 1;
    } else if (leftPressed && !rightPressed){ //Run left
        velocityX -= 0.2*deltaTime;
        rightLeft = true;
        if(jumpPossible) animMode = 1;
    } else if(velocityX > 0){ //Stop running right when button isn't held down
      velocityX -= 0.2*deltaTime;
    } else if(velocityX < 0){ //Stop running left when button isn't held down
      velocityX += 0.2*deltaTime;
    }
    
    if(velocityX > 4) velocityX = 4;
    if(velocityX < -4) velocityX = -4;
    if(velocityX > -0.1 && velocityX < 0.1) {
    animMode = 0;
    velocityX = 0;
  }
    
    jumpPossible = false;


    
    
    //rect(frontEndPosX + velocityX*10, frontEndPosY+velocityY*10 , 26,32);
    
    //println(frontEndPosY);
    for (int i = 0; i<LevelSetup.currentTableCellCount; i++){
      if (groundInstances[i]!=null){
        if((frontEndPosX + playerWidth + velocityX > groundInstances[i].posX && //player right edge past ground left-side
        frontEndPosX + velocityX < groundInstances[i].posX + 32 && //player left edge past ground right-side
        frontEndPosY + playerHeight > groundInstances[i].posY && //player bottom edge past ground top
        frontEndPosY < groundInstances[i].posY + 32) //player top edge past ground bottom 
        || posX+velocityX<0){ //for scrolling: stops Mario from going past the left edge
          velocityX = 0;
        }
        if(frontEndPosX + playerWidth > groundInstances[i].posX && //player right edge past ground left-side
        frontEndPosX < groundInstances[i].posX + 32 && //player left edge past ground right-side
        frontEndPosY + playerHeight + velocityY > groundInstances[i].posY && //player bottom edge past ground top
        frontEndPosY + velocityY < groundInstances[i].posY + 32){ //player top edge past ground bottom 
          velocityY = 0;
        }
        if(frontEndPosX + playerWidth > groundInstances[i].posX && //player right edge past ground left-side
        frontEndPosX < groundInstances[i].posX + 32 && //player left edge past ground right-side
        frontEndPosY + playerHeight > groundInstances[i].posY && //player bottom edge past ground top
        frontEndPosY < groundInstances[i].posY + 32){ //player top edge past ground bottom 
          
          if (posY<(groundInstances[i].posY+16)){ //If Mario clips in the top half, tp to top
            posY = groundInstances[i].posY-playerHeight; 
            println("DOOR STUCK! DOOR STUCK! 1");
          } else if (posY>(groundInstances[i].posY+16)){ //If Mario clips in the bottom half, tp to the bottom
            posY = groundInstances[i].posY+32; 
            println("DOOR STUCK! DOOR STUCK! 2");
          }
        }
      }
    }
    //rect(frontEndPosX, frontEndPosY, 26,32);
    
    println(velocityX);
    if(posX>=224 && velocityX>0){
      scroll=true;
    } else {
      scroll=false;
    }
    
    if (!scroll){
      posX += velocityX;
      
    }
    posY += velocityY;
    
            //Snap to grid
    frontEndPosX = round(posX/2)*2;
    frontEndPosY = round(posY/2)*2;
    
  }
  
    void Display(){
      println(animMode);
    switch (animMode){
                case 0:
                if(!rightLeft){
                image(spritesSmallMario[0], frontEndPosX,frontEndPosY);
                } else {
                pushMatrix();
                scale(-1,1);
                image(spritesSmallMario[0], -frontEndPosX,frontEndPosY);
                popMatrix();
                }
                break;
                
                case 1:
                if(!rightLeft){
                if(frameCount%round(6-velocityX)==0 && currentFrame <3){
                currentFrame++;
                } else if(frameCount%round(6-velocityX)==0) currentFrame = 1;
                image(spritesSmallMario[currentFrame], frontEndPosX,frontEndPosY);
                } else {
                pushMatrix();
                scale(-1,1);
                if(frameCount%round(6+velocityX)==0 && currentFrame <3){
                currentFrame++;
                } else if(frameCount%round(6+velocityX)==0) currentFrame = 1;
                image(spritesSmallMario[currentFrame], -frontEndPosX,frontEndPosY);
                popMatrix();
                }
                break;
                
              }
    
    //fill(#D45756);
    //rect(frontEndPosX,frontEndPosY,playerWidth ,playerHeight);
    //println(posX+" "+ posY);
    //println("player:  " + frontEndPosX + "  " + (frontEndPosY+playerHeight));
    
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
