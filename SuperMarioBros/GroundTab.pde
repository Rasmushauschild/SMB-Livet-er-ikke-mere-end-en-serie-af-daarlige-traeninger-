class Ground{
    int posX;
    int posY;
    PImage img = loadImage("Sprite_Brick.png");
     
    Ground(int tempX, int tempY){
      posX = tempX;
      posY = tempY;
      
    }
    
    void Display(){
      image(img, posX, posY);
    }
    
}
