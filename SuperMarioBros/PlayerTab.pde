class Player{
  float posX;
  float posY;
  float playerWidth = 26;
  float playerHeight = 32;
  float velocityX;
  float velocityY;
  float frontEndPosX;
  float frontEndPosY;
  boolean jumpPossible;
  boolean gravity;
  boolean scroll;
  public boolean rightPressed;
  public boolean leftPressed;
  public boolean spacePressed;
  PImage img = loadImage("Sprite_Mario01.png");

  Player(float tempX,float tempY){
    posX = tempX;
    posY = tempY;
    }
    
  void Movement(){

    //Left-right movement
    if (rightPressed && !leftPressed){
      velocityX += 0.2*deltaTime;
    } else if (leftPressed && !rightPressed){
        velocityX -= 0.2*deltaTime;
    } else if(velocityX > 0){
      velocityX -= 0.2*deltaTime;
    } else if(velocityX < 0){
      velocityX += 0.2*deltaTime;
    }
    if(velocityX > 4) velocityX = 4;
    if(velocityX < -4) velocityX = -4;
    if(velocityX > -0.011 && velocityX < 0.011) velocityX = 0;
    
    for (int i = 0; i<LevelSetup.currentTableCellCount; i++){
      if (groundInstances[i]!=null){
        if(frontEndPosX + playerWidth > groundInstances[i].posX && //player right edge past ground left-side
        frontEndPosX < groundInstances[i].posX + 32 && //player left edge past ground right-side
        frontEndPosY+playerHeight == groundInstances[i].posY){ //player top edge past ground bottom 
          jumpPossible = true;
        }
      }
    }  
    //println(jumpPossible);
    
    
    if(spacePressed && jumpPossible){
      velocityY=-6;
    }
    jumpPossible = false;
    
    //Gravity
    velocityY += 0.2*deltaTime;
    
    
    //rect(frontEndPosX + velocityX*10, frontEndPosY+velocityY*10 , 26,32);
    
    //println(frontEndPosY);
    for (int i = 0; i<LevelSetup.currentTableCellCount; i++){
      if (groundInstances[i]!=null){
        if(frontEndPosX + playerWidth + velocityX > groundInstances[i].posX && //player right edge past ground left-side
        frontEndPosX + velocityX < groundInstances[i].posX + 32 && //player left edge past ground right-side
        frontEndPosY + playerHeight > groundInstances[i].posY && //player bottom edge past ground top
        frontEndPosY < groundInstances[i].posY + 32){ //player top edge past ground bottom 
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
    
    println(posX);
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
    image(img, frontEndPosX,frontEndPosY);
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
