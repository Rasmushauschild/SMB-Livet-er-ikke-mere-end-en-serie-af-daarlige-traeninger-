class Ground{
    int posX;
    int posY;
     
    Ground(int tempX, int tempY){
      posX = tempX;
      posY = tempY;
      
    }
    
    void Display(){
      fill(#CA8F61);
      rect(posX,posY,32,32);
    }
    
}
