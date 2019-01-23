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
    
  void Display(){
    posX += velocityX;
    posY += velocityY;

    fill(255,30,30);
    rect(posX+velocityX,posY,26,32);
    println(velocityX);
  }
  
  void Movement(){
    
    if (velocityX > 0) velocityX -= 0.1;
    if (velocityX < 0) velocityX += 0.1;
    if(velocityX > -0.1 && velocityX < 0.01) velocityX = 0;
 
    if (!(Player.rightPressed && Player.leftPressed)){ //Dis no works #fuckkk!!
    if (rightPressed){
    velocityX += 0.2;
    }
    
    if (leftPressed){
    velocityX -= 0.2;
    }
    }
  }
}

void KeyReleased(){
if (keyCode == RIGHT) Player.rightPressed = false;
if (keyCode == LEFT) Player.leftPressed = false;
}

void KeyPressed(){
if (keyCode == RIGHT) Player.rightPressed = true;
if (keyCode == LEFT) Player.leftPressed = true;
}
