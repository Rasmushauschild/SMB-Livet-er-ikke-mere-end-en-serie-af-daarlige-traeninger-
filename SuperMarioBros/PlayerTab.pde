class Player{
  float posX;
  float posY;
  float playerWidth = 26;
  float playerHeight = 32;
  float velocityX;
  float velocityY;
  float frontEndPosX;
  float frontEndPosY;
  boolean movementPossible;
  boolean gravity;
  public boolean rightPressed;
  public boolean leftPressed;
  public boolean spacePressed;

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
    
    
    
          for (int i = 0; i<LevelSetup.currentTableCellCount; i++){ //For-loop for displaying every groundInstance. Checks every possible tablecell. 
      if (groundInstances[i]!=null){ 
      if ((((frontEndPosX + velocityX > groundInstances[i].posX && frontEndPosX + velocityX < groundInstances[i].posX +32) ||
      (frontEndPosX + playerWidth + velocityX > groundInstances[i].posX && frontEndPosX + velocityX + playerWidth < groundInstances[i].posX +32)) && //↑X Y↓
      (
      (frontEndPosY + playerHeight + velocityY > groundInstances[i].posY -1 && frontEndPosY + velocityY + playerHeight <= groundInstances[i].posY +32)))){
          gravity = false;
        }
      }
    }

    println(velocityY);
    if (gravity){
        velocityY += 0.2*deltaTime;
    }
    else velocityY = 0;
    
    
    gravity = true;
    
      for (int i = 0; i<LevelSetup.currentTableCellCount; i++){ //For-loop for displaying every groundInstance. Checks every possible tablecell. 
      if (groundInstances[i]!=null){ 
      if ((((frontEndPosX + velocityX > groundInstances[i].posX && frontEndPosX + velocityX < groundInstances[i].posX +32) ||
      (frontEndPosX + playerWidth + velocityX > groundInstances[i].posX && frontEndPosX + velocityX + playerWidth < groundInstances[i].posX +32)) && //↑X Y↓
      ((frontEndPosY + velocityY > groundInstances[i].posY && frontEndPosY + velocityY < groundInstances[i].posY +32) ||
      (frontEndPosY+ playerHeight + velocityY > groundInstances[i].posY && frontEndPosY + velocityY + playerHeight <= groundInstances[i].posY +32)))){ //<= is for pixel perfect BS
          movementPossible = false;
        }
      }
    }
    
    if (movementPossible){
      posX += velocityX;
      posY += velocityY;
    }
    movementPossible = true;
    
            //Snap to grid
    frontEndPosX = round(posX/2)*2;
    frontEndPosY = round(posY/2)*2;
    
  }
  
    void Display(){
    fill(#D45756);
    rect(frontEndPosX,frontEndPosY,playerWidth ,playerHeight);
    //println(posX+" "+ posY);
  }
}

void keyReleased(){
  println("Key Released");
  if (keyCode == RIGHT) Player.rightPressed = false;
  if (keyCode == LEFT) Player.leftPressed = false;
  if (keyCode == 32) Player.spacePressed = false;
}

void keyPressed(){
  println("Key Pressed");
  if (keyCode == RIGHT) Player.rightPressed = true;
  if (keyCode == LEFT) Player.leftPressed = true;
  if (keyCode == 32) Player.spacePressed = true;
}
