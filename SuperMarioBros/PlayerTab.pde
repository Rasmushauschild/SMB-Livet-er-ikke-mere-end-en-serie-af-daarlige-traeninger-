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
  boolean facingRight=true;
  public boolean rightPressed;
  public boolean leftPressed;
  public boolean spacePressed;
  
  int animCount;
  PImage spriteSheetSmallMario;
  PImage[] spritesSmallMario = new PImage[13]; //Creates an empty PImage array with the correct length

  Player(float tempX,float tempY){
    posX = tempX;
    posY = tempY;
    }
    
  void animationSetup(){
    animCount = 14;
    spriteSheetSmallMario = loadImage("SpriteSheet_SmallMario.png"); //Loads the spritesheet
    
    int W = spriteSheetSmallMario.width/animCount;
    
    for(int i = 0; i<spritesSmallMario.length; i++){
    int x = i%animCount*W;
    spritesSmallMario[i]=spriteSheetSmallMario.get(x,0,W,spriteSheetSmallMario.height);
    }
  }
    
  void Movement(){
    //Resets animMode
    for (int i = 0; i<LevelSetup.currentTableCellCount; i++){ //Checks whether or not player is touching ground, determines if player can jump
      if (blockInstances[i]!=null){
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
    
    
    //Gravity
    velocityY += 0.2*deltaTime;
    
    
    if(velocityY > 6) velocityY = 6; //Max-fallspeed
    
    
    //LEFT-RIGHT MOVEMENT ---------------------------------------------------
    
    if (rightPressed && !leftPressed){ //Run right
      velocityX += 0.2*deltaTime;
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
    
    if(velocityX > 4) velocityX = 4;
    if(velocityX < -4) velocityX = -4;
    if(velocityX > -0.1 && velocityX < 0.1) {
    velocityX = 0;
    if(jumpPossible) animMode = 0;
  }
    if(spacePressed && jumpPossible){ //Jump when space is pressed and player is on ground.
    animMode = 2;
    }
    println(jumpPossible);
    jumpPossible = false;


    
    
    //rect(frontEndPosX + velocityX*10, frontEndPosY+velocityY*10 , 26,32);
    
    //println(frontEndPosY);
    for (int i = 0; i<LevelSetup.currentTableCellCount; i++){
      if (blockInstances[i]!=null){
        if((frontEndPosX + playerWidth + velocityX > blockInstances[i].posX && //player right edge past ground left-side
        frontEndPosX + velocityX < blockInstances[i].posX + 32 && //player left edge past ground right-side
        frontEndPosY + playerHeight > blockInstances[i].posY && //player bottom edge past ground top
        frontEndPosY < blockInstances[i].posY + 32) //player top edge past ground bottom 
        || posX+velocityX-playerWidth/2<0){ //for scrolling: stops Mario from going past the left edge
          velocityX = 0;
        }
        if(frontEndPosX + playerWidth > blockInstances[i].posX && //player right edge past ground left-side
        frontEndPosX < blockInstances[i].posX + 32 && //player left edge past ground right-side
        frontEndPosY + playerHeight + velocityY > blockInstances[i].posY && //player bottom edge past ground top
        frontEndPosY + velocityY < blockInstances[i].posY + 32){ //player top edge past ground bottom 
          velocityY = 0;
        }
        if(frontEndPosX + playerWidth > blockInstances[i].posX && //player right edge past ground left-side
        frontEndPosX < blockInstances[i].posX + 32 && //player left edge past ground right-side
        frontEndPosY + playerHeight > blockInstances[i].posY && //player bottom edge past ground top
        frontEndPosY < blockInstances[i].posY + 32){ //player top edge past ground bottom 
          
          if (posY<(blockInstances[i].posY+16)){ //If Mario clips in the top half, tp to top
            posY = blockInstances[i].posY-playerHeight; 
            println("DOOR STUCK! DOOR STUCK! 1");
          } else if (posY>(blockInstances[i].posY+16)){ //If Mario clips in the bottom half, tp to the bottom
            posY = blockInstances[i].posY+32; 
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
  
    void Display(){ //FIX MARIO SPRITESHEET - FRAMES NOT CENTERED
      println(animMode);
    switch (animMode){
                case 0: //Standing still Right/Left
                if(facingRight){
                image(spritesSmallMario[0], frontEndPosX,frontEndPosY);
                } else {
                pushMatrix();
                scale(-1,1);
                image(spritesSmallMario[0], -frontEndPosX,frontEndPosY);
                popMatrix();
                }
                break;
                
                case 1: //Running Right/Left
                if(facingRight){
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
                
                case 2: //Jumping Right/Left
                if(facingRight){
                image(spritesSmallMario[5], frontEndPosX,frontEndPosY);
                } else {
                pushMatrix();
                scale(-1,1);
                image(spritesSmallMario[5], -frontEndPosX,frontEndPosY);
                popMatrix();
                }
                break;
                
                case 3:
                if(facingRight){
                image(spritesSmallMario[4], frontEndPosX,frontEndPosY);
                } else {
                pushMatrix();
                scale(-1,1);
                image(spritesSmallMario[4], -frontEndPosX,frontEndPosY);
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
