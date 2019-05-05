class Block{
    boolean animationInProgress = false;
    float posX;
    float posY;
    float startPosX;
    float sizeX;
    float sizeY;
    Table pipeTable = loadTable("pipeData.csv");
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
    
    Block(float tempX, float tempY, int tempIdentifier, int temptvalue){
      startPosX = tempX;
      posX = tempX;
      posY = tempY;
      identifier = tempIdentifier;
      tvalue = temptvalue;
      
      
      if (identifier >= 95 && identifier <= 102){
        localPipeIdentifier = publicPipeIdentifier;
        //int[] pipeArray = new int[localPipeIdentifier]; 
        pipeArray[localPipeIdentifier] = tvalue;
        
        println(localPipeIdentifier + " " + tvalue);
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
        
        case 91: //left vertical pipe
        image(pipeL, posX, posY);
        break;

        case 92: //right vertical pipe
        image(pipeR, posX, posY);
        break;
        
        case 93: //top horizontal pipe
        pushMatrix();
        translate(posX,posY); //move origin to pivot point
        rotate(radians(90)); //pivot grid 90 degrees
        image(pipeL, 0, 0);
        popMatrix();
        break;

        case 94: //bottom horizontal pipe
        pushMatrix();
        translate(posX,posY); //move origin to pivot point
        rotate(radians(90)); //pivot grid 90 degrees
        image(pipeR, 0, 0);
        popMatrix();
        break;
        
        case 95: //leftGoingUpwardsPipe
        image(pipeTopL, posX, posY);
        break;

        case 96: //rightGoingUpwardsPipe
        image(pipeTopR, posX, posY);
        break;
        
        case 97: //topGoingLeftPipe
        pushMatrix();
        translate(posX,posY); //move origin to pivot point
        rotate(radians(90)); //pivot grid 90 degrees
        image(pipeTopL, 0, 0);
        popMatrix();
        break;
        
        case 98: //bottomGoingLeftPipe
        pushMatrix();
        translate(posX,posY); //move origin to pivot point
        rotate(radians(90)); //pivot grid 90 degrees
        image(pipeTopR, 0, 0);
        popMatrix();
        break;
        
        case 99: //topGoingRightPipe
        pushMatrix();
        translate(posX,posY); //move origin to pivot point
        rotate(radians(90)); //pivot grid 90 degrees
        image(pipeTopL, 0, 0);
        popMatrix();
        break;
        
        case 100: //bottomGoingRightPipe
        pushMatrix();
        translate(posX,posY); //move origin to pivot point
        rotate(radians(90)); //pivot grid 90 degrees
        image(pipeTopR, 0, 0);
        popMatrix();
        break;
        
        case 101: //leftGoingDownwardsPipe
        pushMatrix();
        translate(posX,posY); //move origin to pivot point
        rotate(radians(180)); //pivot grid 90 degrees
        image(pipeTopR, 0, 0);
        popMatrix();
        break;
        
        case 102: //rightGoingDownwardsPipe
        pushMatrix();
        translate(posX,posY); //move origin to pivot point
        rotate(radians(180)); //pivot grid 90 degrees
        image(pipeTopL, 0, 0);
        popMatrix();
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
    
    void ActivatedVerticalPipe(){ //Player has activated a block by clicking right/left or up/down in it its direction while directly touching it
      if (identifier == 95 || identifier == 96 || identifier == 101 || identifier == 102){ //Makes sure the activated block is a pipe with a vertical orientation
        for(int i=0;i<pipeTable.getColumnCount();i++){ //Go through the pipeData for this level
          int currentPipeID = pipeTable.getInt(0,i); //Get the pipeID's from the pipeTable. Rows start at 0. 0 should be replaced with currentLevelInt         
          if (currentPipeID == localPipeIdentifier && i%2==0){ //If the activated pipe is in the pipeData for this level, and the pipe is an entry pipe
            int destinationPipeID = pipeTable.getInt(0,i+1); //Find the pipeID of the pipe Mario has to travel to by using the pipeData.csv file
            int destinationPipetvalue = pipeArray[destinationPipeID]; //Find the tvalue for for the destination pipe
            int destinationPipeIdentifier = blockInstances[destinationPipetvalue].identifier;
            
            if (identifier == 95 || identifier == 96){ //If the entry pipe is pointing upwards, the entry pipe movement should be downwards
              Player.entryPipeMovement = 0;
              println("Entrypipemovent is set to 0");
            } else if (identifier == 101 || identifier == 102){ //If the entry pipe is pointing downwards, the entry pipe movement should be upwards
              Player.entryPipeMovement = 2;
            } 
            
            println("destinationPipeID: " + destinationPipeID);
            if (destinationPipeIdentifier == 95 || destinationPipeIdentifier == 96){ //If the destination pipe points upwards, the exit pipe movement should be upwards
              Player.exitPipeMovement = 2;
            } else if (destinationPipeIdentifier == 101 || destinationPipeIdentifier == 102){ //If the destination pipe points downwards, the exit pipe movement should be downwards
              Player.exitPipeMovement = 0;
              println("Exitpipemovent is set to 0");
            } else if (destinationPipeIdentifier == 97 || destinationPipeIdentifier == 98){ //If the exit pipe points leftwards, the exit pipe movement should be leftwards
              Player.exitPipeMovement = 3;
            } else if (destinationPipeIdentifier == 99 || destinationPipeIdentifier == 100){ //If the exit pipe points rightwards, the exit pipe movement should be rightwards
              Player.exitPipeMovement = 1;
            }
            
            Player.pipeDestinationY = blockInstances[destinationPipetvalue].posY;
            Player.pipeDestinationScrollAmount = scrollAmount + (blockInstances[destinationPipetvalue].posX-blockInstances[tvalue].posX);
            Player.pipeAction = 1;
            Player.pipeStartX = Player.posX;
            Player.pipeStartY = Player.posY;
          }
        }
      }
    }
    
    void ActivatedHorizontalPipe(){ //Player has activated a block by clicking right/left or up/down in it its direction while directly touching it
      if (identifier >= 97 && identifier <= 100){ //Makes sure the activated block is a pipe with a horizontal orientation
        for(int i=0;i<pipeTable.getColumnCount();i++){ //Go through the pipeData for this level
          int currentPipeID = pipeTable.getInt(0,i); //Get the pipeID's from the pipeTable. Rows start at 0. 0 should be replaced with currentLevelInt         
          if (currentPipeID == localPipeIdentifier && i%2==0){ //If the activated pipe is in the pipeData for this level, and the pipe is an entry pipe
            int destinationPipeID = pipeTable.getInt(0,i+1); //Find the pipeID of the pipe Mario has to travel to by using the pipeData.csv file
            int destinationPipetvalue = pipeArray[destinationPipeID]; //Find the tvalue for for the destination pipe
            int destinationPipeIdentifier = blockInstances[destinationPipetvalue].identifier;
            
            if (identifier == 97 || identifier == 98){ //If the entry pipe points leftwards, the entry pipe movement should be rightwards
              Player.entryPipeMovement = 1;
            } else if (identifier == 99 || identifier == 100){ //If the entry pipe points rightwards, the entry pipe movement should be leftwards
              Player.entryPipeMovement = 3;
            }
            
            println("destinationPipeID: " + destinationPipeID);
            if (destinationPipeIdentifier == 95 || destinationPipeIdentifier == 96){ //If the destination pipe points upwards, the exit pipe movement should be upwards
              Player.exitPipeMovement = 2;
            } else if (destinationPipeIdentifier == 101 || destinationPipeIdentifier == 102){ //If the destination pipe points downwards, the exit pipe movement should be downwards
              Player.exitPipeMovement = 0;
              println("Exitpipemovent is set to 0");
            } else if (destinationPipeIdentifier == 97 || destinationPipeIdentifier == 98){ //If the exit pipe points leftwards, the exit pipe movement should be leftwards
              Player.exitPipeMovement = 3;
            } else if (destinationPipeIdentifier == 99 || destinationPipeIdentifier == 100){ //If the exit pipe points rightwards, the exit pipe movement should be rightwards
              Player.exitPipeMovement = 1;
            }
            
            
            Player.pipeDestinationY = blockInstances[destinationPipetvalue].posY;
            Player.pipeDestinationScrollAmount = scrollAmount + (blockInstances[destinationPipetvalue].posX-blockInstances[tvalue].posX);
            Player.pipeAction = 1;
            Player.pipeStartX = Player.posX;
            Player.pipeStartY = Player.posY;
          }
        }
      }
    }
    
    
}
