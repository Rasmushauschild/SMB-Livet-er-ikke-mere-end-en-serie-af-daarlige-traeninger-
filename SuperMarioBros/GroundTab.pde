class Ground{
    float posX;
    float posY;
    PImage img = loadImage("Sprite_Brick.png");
     
    Ground(float tempX, float tempY){
      posX = tempX;
      posY = tempY;
      
    }
    
    void Display(){
      image(img, posX, posY);
    }
    
    void Scroll(){
      posX = posX-Player.velocityX;
      posX = round(posX/2)*2;
    }
    
}
