class Player{
  float posX;
  float posY;
  float velocityX;
  float velocityY;

  Player(float tempX,float tempY){
    posX = tempX;
    posY = tempY;
    
    }
    
  void Display(){
    fill(255,30,30);
    rect(posX+velocityX,posY,26,32);
    println(velocityX);
  }
  
  void MoveRight(){
  velocityX += 5;
  }
  
  void MoveLeft(){
  velocityX -= 5;
  }


}