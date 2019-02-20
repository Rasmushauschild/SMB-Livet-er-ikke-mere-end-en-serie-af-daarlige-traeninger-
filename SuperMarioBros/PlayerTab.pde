class Player{
  float posX;
  float posY;
  float velocityX;
  float velocityY;
  public boolean rightPressed;
  public boolean leftPressed;

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
    posX += velocityX;
    posY += velocityY;
    
    //Snap to grid
    posX = round(posX/2)*2;
    posY = round(posY/2)*2;
  }
  
    void Display(){
    fill(255,30,30);
    rect(posX,posY,26,32);
    println(posX+" "+ posY);
  }
}

void keyReleased(){
  println("Key Released");
  if (keyCode == RIGHT) Player.rightPressed = false;
  if (keyCode == LEFT) Player.leftPressed = false;
}

void keyPressed(){
  println("Key Pressed");
  if (keyCode == RIGHT) Player.rightPressed = true;
  if (keyCode == LEFT) Player.leftPressed = true;
}
