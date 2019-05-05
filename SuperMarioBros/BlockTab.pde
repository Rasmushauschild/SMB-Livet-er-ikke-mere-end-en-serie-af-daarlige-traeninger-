class Block{
    boolean animationInProgress = false;
    float posX;
    float posY;
    float startPosX;
    float sizeX;
    float sizeY;
    Table pipeTable = loadTable("pipeData.csv");
    int[] pipeArray = new int[0]; //Initiliasizes array and sets length 0 - length is increased in the constructor when it becomes neccessary
    int identifier;
    int localPipeIdentifier; //Local version of the pipeIdentifier value. Makes sure each pipe-top has it's own unique ID.
    int tvalue;
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
    
    //Values specifically for pipes
    int pipeID = 0;
    
    Block(float tempX, float tempY, int tempIdentifier, int temptvalue){
      startPosX = tempX;
      posX = tempX;
      posY = tempY;
      identifier = tempIdentifier;
      tvalue = temptvalue;
      
      
      if (identifier == 91 || identifier == 92){
        localPipeIdentifier = publicPipeIdentifier;
        int[] pipeArray = new int[localPipeIdentifier]; 

        
        publicPipeIdentifier++;
      }
      
    }
    
    void Display(){
      posX = startPosX-scrollAmount;

      
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
          frameCountSinceBeingHit =0;
        } else if (animationInProgress){
          image(itemSprite, posX, round(posY+pow(frameCountSinceBeingHit,2)-10*frameCountSinceBeingHit-1));
          frameCountSinceBeingHit = frameCount - frameCountWhenHit;
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
    
    void ActivatedBelow (){ //Player has jumped up into this block from below
      switch(identifier){
        case 4: //Item block        
        mushroomInstances[mushroomIdentifier] = new Mushroom(posX, posY-64);
        mushroomInstances[mushroomIdentifier].animationSetup();
        animationInProgress = true;
        frameCountWhenHit = frameCount;
        mushroomIdentifier++;
        break;     
      
      }
    
    }
    
    void ActivatedAbove(){ //Player has hit the downbutton while standing on this block.
      switch (identifier){
        case 91: //pipeTopL
        case 92: //pipeTopR
        for(int t=0;t<=pipeTable.getColumnCount();t++){
          int currentPipeID = pipeTable.getInt(LevelSetup.currentLevel,t);
          if (currentPipeID == pipeID){
            if (t%2==0){
              
            }
          
          }
        
        }
        
        
        
        break;
        
      
      
      }
    
    
    }
    
    
    void Scroll(){
      //posX = posX-Player.velocityX;
      //posX = round(posX/2)*2;
    }
    
}
