/*
Super Mario Bros. Created by Alsing and True (Rasmus A. Haushild and Joachim L. Sand).
USEFUL INFORMATION--------------------------
The word menu is used pretty interchangebly with HUD/UI
The games default speed is 60 FPS.
Level size in pixels: 7042,448
Level size in blocks: 221, 14

Window size in pixels (2x original): 512, 448
Window size in blocks: 16, 14

Blocks Mario can move before screen moves with him: 7
--------------------------------------------
*/


import processing.sound.*; //Imports the processing sound library.

//Declare variables for sounds
SoundFile mainTheme;
SoundFile UGTheme;
SoundFile breakBlock;
SoundFile coin;
SoundFile death;
SoundFile flagPoleSound;
SoundFile jump;
SoundFile mushroomAppears;
SoundFile pause;
SoundFile pipe;
SoundFile powerUp;
SoundFile stomp;

Player Player; //Declare class player
LevelSetup LevelSetup; //Declare class LevelSetup 
Block Block; //Declare class Block
Block[] blockInstances; //Create a array with name blockInstances, containing instances of the Block class.
Goomba Goomba; //Declare class Goomba
Goomba[] goombaInstances; //Create a array with name goombaInstances, containing instances of the Goomba class.
Collectible Collectible; //Declare class collectibles
Collectible[] collectibleInstances; //Create a array with name collectibleInstances, containing instances of the Collectible class.
Menu Menu; //Declare class Menu
Menu[] menuInstances; //Create a array with name menuInstances, containing instances of the Menu class.
Background Background; //Declare class Background
Background[] backgroundInstances; //Create a array with name backgroundInstances, containing instances of the Background class.

PFont mainFont; //Declare mainFont used for the game. 
float scrollAmount; //Declare scrollAmount. Used for tracking how much the current scene/level has been scrolled
float frameCountWhenLoadingStarted;
int gameState; //Responsible for the state of the game - 0: Main menu, 1: Level Loading Screen, 2: Gameplay 3
int collectibleIdentifier = 0; //For creating collectibles with seperate names
int publicPipeIdentifier = 0; //For creating ID for pipes which can be used by Mario. 
int[] pipeArray = new int[100]; //Initiliasizes array and sets length to 100 - setting a max of 50 pipes per level. Is used to keep track of pipes.
color backgroundColor; //Declare color for background. 

//Values concerning deltaTime and its calculation
float currentTime; 
float prevTime;
float deltaTime; //deltaTime represent the time which passed between each frame. Is used to create consistent movement for every computer, even though frame rates might vary.

//Values concerning the HUD.
int timeLeft = 400; //TimeLeft is the amount of time left in a level in seconds. Is reset every time a level is loaded.
int millisAtStartOfLevel; //Used to keeping the HUD-timer working. Is reset every time a level is loaded.
int world = 1; //Keeps track of which world Mario is in. Each world contains 4 levels.
int levelInWorld = 1; //The current level in the current world.
int score; //Score Mario has achieved in his current run.
int coins; //Amount of coins Mario has collected.
int livesLeft = 3; //Amount of lives Mario has left
int currentPalette; //The palette of the game. 0 is overworld (the usual palette SMB has) and 1 is underground (dark blueish).

void setup(){
    size(512,448);
    imageMode(CENTER);  
  
    //Load soundfiles for game
    mainTheme = new SoundFile(this, "Track_Main.wav");
    UGTheme = new SoundFile(this, "Track_UG.wav");
    breakBlock = new SoundFile(this, "SFX_BreakBlock.wav");
    coin = new SoundFile(this, "SFX_Coin.wav");
    death = new SoundFile(this, "SFX_Death.wav");
    flagPoleSound = new SoundFile(this, "SFX_Flagpole.wav");
    jump = new SoundFile(this, "SFX_Jump.wav");
    mushroomAppears = new SoundFile(this, "SFX_MushroomAppears.wav");
    pause = new SoundFile(this, "SFX_Pause.wav");
    pipe = new SoundFile(this, "SFX_Pipe.wav");
    powerUp = new SoundFile(this, "SFX_PowerUp.wav");
    stomp = new SoundFile(this, "SFX_Stomp.wav");
    
    loadSprites(0); //Load Sprites based on palette. (0 is overworld, 1 is underground).
    
    mainFont = loadFont("Super-Mario-Bros.-NES-48.vlw"); //Load SMB font.
    textFont(mainFont,14); //Double the height of the original
    
    LevelSetup = new LevelSetup(); //Init LevelSetup class
    LevelSetup.loadScene(0); //Load Main Menu
    
    //Spawn Player
    Player = new Player(144, 400);
    Player.animationSetup();
    
    //AnimationSetup for every Goomba. Is in a for-loop in order to reach every instance of the Goomba.
    for (int i = 0; i<LevelSetup.currentTableCellCount;i++){
    if(goombaInstances[i]!=null) {
      goombaInstances[i].animationSetup();
    }
  }
}

void draw(){
  deltaTimeCalculation(); //Calculate deltaTime
  switch(gameState){ //Whatever is done each frame should be determined by the gameState.
    case 0: //Main Menu
      background(backgroundColor);
      for (int i = 0; i<LevelSetup.currentTableCellCount;i++){if(backgroundInstances[i]!=null) backgroundInstances[i].Display();}
      Player.PlayerActive();
      for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every blockInstance. Checks every possible tablecell. 
        if(blockInstances[i]!=null) blockInstances[i].Display();
        if(goombaInstances[i]!=null) goombaInstances[i].Alive();
        if(collectibleInstances[i]!=null) collectibleInstances[i].Alive();  
        if(menuInstances[i]!=null) menuInstances[i].Active();
      }

    break;
    
    case 1: //Loading Scene
      background(0);
      pauseMusic(); //Pause when loading a new scene.
          
      if(frameCountWhenLoadingStarted + 333 > frameCount){ //Display the loading screen for 333 frames.
        for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //Display every MenuInstance.   
          if(menuInstances[i]!=null){
            menuInstances[i].Active();
          }
        }
      } else { //LOAD NEXT LEVEL
        switch (LevelSetup.currentLevel){ //Load appropiate palette for level
          case 0:
          case 1: //Overworld level
            loadSprites(0);
          break;
          case 2: //Underground level
            loadSprites(1);
          break;
        }
        LevelSetup.loadScene(LevelSetup.currentLevel); //Load the level
        timeLeft = 400; //Reset timer
        millisAtStartOfLevel = millis(); //Reset timer for the level
        if (LevelSetup.currentLevel != 0){ //Any level
          frameCountWhenLoadingStarted = frameCount; //Resets the timer for when to end the loading screen. Is not done when returning to the main menu, so as to avoid loading screen.
          gameState = 2; //Change the game state accordingly, so that the player has control over the player
        } else { //Main Menu
          gameState = 0;
        }
        scrollAmount = 0; //Reset ScrollAmount
        Player = new Player(144, 400); //Spawn a new player in the new scene.
        Player.animationSetup();
        publicPipeIdentifier = 0; //Reset
        for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //Animation setup for every Gomba.
          if(goombaInstances[i]!=null) {
          goombaInstances[i].animationSetup();
          }
        }
        
        
      }
    break;
    
    
    case 2:
      if (timeLeft > 0) //If there is time left, subtract time accordingly from the timer.
        timeLeft = 400 - (millis()-millisAtStartOfLevel)/1000;
      else { //If there is no time left, kill the player
        Player.Death();
      }      
      background(backgroundColor);
      for (int i = 0; i<LevelSetup.currentTableCellCount;i++){if(backgroundInstances[i]!=null) backgroundInstances[i].Display();}
      for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //Display blocks, Goombas and collectibles. 
        if(blockInstances[i]!=null) blockInstances[i].Display();
        if(goombaInstances[i]!=null) goombaInstances[i].Alive();
        if(collectibleInstances[i]!=null) collectibleInstances[i].Alive(); 
      }
            Player.PlayerActive();
      for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //Display menu (HUD). Has to be last and in its own loop to make sure it's displayed on top of everything else.
        if(menuInstances[i]!=null) menuInstances[i].Active();
      }
    break;
  }
}

void loadNextScene(){ //Go to the loading level scene
  println("next scene loaded...");
  LevelSetup.currentLevel ++;
  gameState = 1;
  LevelSetup.loadScene(-1); //Load the load-level scene
  frameCountWhenLoadingStarted = frameCount; //Used for the amount of frames the loading scene should be displayed
}

void loadCurrentScene(){ //Load the current scene again. Usually when the players dies but has lives left
  println("current scene loaded...");
  collectibleIdentifier = 0;
  gameState = 1;
  LevelSetup.loadScene(-1);
  frameCountWhenLoadingStarted = frameCount;
}

void loadMainMenu(){ //Load main menu. Usually when the player dies but has no lives left
  livesLeft = 3;
  LevelSetup.currentLevel = 0;
  gameState = 1;
  LevelSetup.loadScene(-1);
  gameState = 1;
}


void deltaTimeCalculation(){ //Calculate deltaTime: The time in millis between each frame.
  prevTime = currentTime;
  currentTime = millis();
  deltaTime = (currentTime - prevTime)/20; //Divided by 20 to achieve values of deltaTime which are more workable.
}

void loadSprites(int palette){ //Change sprite pallete based on loaded level
switch(palette){
  case 0: //Palette 0 (Overworld)
    mainTheme.loop(); //Play a different main theme depending on the palette
    currentPalette = palette;
    backgroundColor = #aed1ee;
    groundSprite = loadImage("Sprite_Ground.png");
    itemSprite = loadImage("Sprite_Item.png");
    itemSpriteEmpty = loadImage("Sprite_ItemEmpty.png");
    brickSprite = loadImage("Sprite_Brick.png");
    stoneSprite = loadImage("Sprite_Stone.png");
    spriteSheetGoomba = loadImage("SpriteSheet_Goomba.png");
    break;
    
  case 1: //Palette 1 (Underground)
    UGTheme.loop(); //Play a different main theme depending on the palette
    currentPalette = palette;
    backgroundColor = 0;
    groundSprite = loadImage("Sprite_UGGround.png");
    itemSprite = loadImage("Sprite_UGItem.png");
    itemSpriteEmpty = loadImage("Sprite_UGItemEmpty.png");
    brickSprite = loadImage("Sprite_UGBrick.png");
    stoneSprite = loadImage("Sprite_UGStone.png");
    spriteSheetGoomba = loadImage("SpriteSheet_UGGoomba.png");
  break;
}
    //The following are the same, no matter which palette is selected.
    
    
    pipeL = loadImage("Sprite_PipeL.png");
    pipeR = loadImage("Sprite_PipeR.png");
    pipeTopL = loadImage("Sprite_PipeTopL.png");
    pipeTopR = loadImage("Sprite_PipeTopR.png");
    flagPole = loadImage("Sprite_FlagPole.png");
    
    //Load Images for BackgroundTab
    bushSmall = loadImage("Sprite_BushS.png"); //40
    bushMedium = loadImage("Sprite_BushM.png"); //41
    bushBig = loadImage("Sprite_BushB.png"); //42
    hillSmall = loadImage("Sprite_HillS.png"); //43
    hillBig = loadImage("Sprite_HillB.png"); //44
    cloudSmall = loadImage("Sprite_CloudS.png"); //45
    cloudBig = loadImage("Sprite_CloudB.png"); //46
    castle = loadImage("Sprite_Castle.png");
    
    //Load Images for MenuTab
    coinCounter = loadImage("Sprite_CoinCounter.png");
    cross = loadImage("Sprite_Cross.png");
    
    //Load Images for CollectibleTab
    spriteCoin = loadImage("Sprite_Coin.png");
    spriteMushroom = loadImage ("Sprite_Mushroom.png");

}

void pauseMusic(){ //Function for pausing game music.
  mainTheme.pause();
  UGTheme.pause();
}
