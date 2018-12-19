class Player{
  float posX;
  float posY;

  Player(float tempX,float tempY){
    posX = tempX;
    posY = tempY;
    
    }
    
    
  void display(){
    rect(posX,posY,13,16);
  }
  


}
