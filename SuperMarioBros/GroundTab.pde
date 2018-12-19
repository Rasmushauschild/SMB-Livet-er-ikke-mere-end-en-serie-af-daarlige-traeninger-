class Ground{
    int posX;
    int posY;
     
    Ground(int tempX, int tempY){
      posX = tempX;
      posY = tempY;
      
    }
    
    void Display(){
      fill(100, 155, 30);
      rect(posX,posY,32,32);
    }
    
}
