class Block{
    boolean animationInProgress = false;
    float posX;
    float posY;
    float sizeX;
    float sizeY;
    int identifier;
    PImage groundSprite = loadImage("Sprite_Ground.png");
    PImage itemSprite = loadImage("Sprite_Item.png");
    PImage brickSprite = loadImage("Sprite_Brick.png");
    PImage goombaSprite = loadImage("Sprite_Goomba.png");
    PImage pipeL = loadImage("Sprite_PipeL.png");
    PImage pipeR = loadImage("Sprite_PipeR.png");
    PImage pipeTopL = loadImage("Sprite_PipeTopL.png");
    PImage pipeTopR = loadImage("Sprite_PipeTopR.png");
    
    //Values specifically for mushroom
    int frameCountWhenHit;
    int frameCountSinceBeingHit;
    int mushroomIdentifier = 1; //For creating mushrooms with seperate names
     
    Block(float tempX, float tempY, int tempIdentifier){
      posX = tempX;
      posY = tempY;
      identifier = tempIdentifier;
      
    }
    
    void Display(){
      switch (identifier){
        case 2: //Ground Block
        image(groundSprite, posX, posY);
        break;
        
        case 3: //Brick Block
        image(brickSprite, posX, posY);
        break;
        
        case 4: //Item Block
        //println(animationInProgress);
        if (animationInProgress && round(posY+pow(frameCountSinceBeingHit,2)-10*frameCountSinceBeingHit-1)>=posY){ //Stop animation after 30 frames
          animationInProgress = false;
          println("AnimationStopped"+frameCount);
          frameCountSinceBeingHit =0;
        } else if (animationInProgress){
          image(itemSprite, posX, round(posY+pow(frameCountSinceBeingHit,2)-10*frameCountSinceBeingHit-1));
          frameCountSinceBeingHit = frameCount - frameCountWhenHit;
          println(frameCountSinceBeingHit);
        } else {
          image(itemSprite, posX, posY);
        }
                break;
        
        case 93:
        image(pipeL, posX, posY);
        break;

        case 94:
        image(pipeR, posX, posY);
        break;

        case 91:
        image(pipeTopL, posX, posY);
        break;

        case 92:
        image(pipeTopR, posX, posY);
        break;

        case 20:
        image(goombaSprite, posX, posY);
        break;
      }
      
      
      
    }
    
    void ActivatedBelow (){
      switch(identifier){
        case 4: //Item block
        println("Hit Item Block" + frameCount);
        
        mushroomInstances[mushroomIdentifier] = new Mushroom(posX, posY-32);
        mushroomInstances[mushroomIdentifier].animationSetup();
        animationInProgress = true;
        frameCountWhenHit = frameCount;
        mushroomIdentifier++;
        break;     
      
      }
    
    
    }
    
    
    void Scroll(){
      posX = posX-Player.velocityX;
      posX = round(posX/2)*2;
    }
    
}
