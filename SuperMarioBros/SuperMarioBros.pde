import processing.sound.*; //Imports the processing sound library.

//Declare variables for sounds
SoundFile mainTheme;
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

LevelSetup LevelSetup;
Block Block; //Declare object Block
Block[] blockInstances; //Create a array of name blockInstances, containing instances of the Block class.
Goomba Goomba;
Goomba[] goombaInstances;
Player Player;
Collectible Collectible;
Collectible[] collectibleInstances;
Menu Menu;
Menu[] menuInstances;
Background Background;
Background[] backgroundInstances;
PFont mainFont;
float scrollAmount;
float currentTime;
float prevTime;
float deltaTime;
float frameCountWhenLoadingStarted;
int gameState; //Responsible for the state of the game - 0: Main menu 1: LevelLoad 2: Gameplay 3:Paused Gameplay
int collectibleIdentifier = 0; //For creating collectibles with seperate names
int publicPipeIdentifier = 0; //For creating ID for pipes which can be used by Mario. 
int[] pipeArray = new int[100]; //Initiliasizes array and sets length to 100 - setting a max of 50 pipes per level
color backgroundColor;

int timeLeft = 400;
int millisAtStartOfLevel;
int world = 1;
int levelInWorld = 1;
int score;
int coins; 
int livesLeft = 3; //Amount of lives Mario has left


void setup(){
    
    //Load soundfiles for game
    mainTheme = new SoundFile(this, "Track_Main.wav");
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

    
    //60 FPS
    //Level size in pixels: 7042,448
    //Level size in blocks: 221, 14

    //Window size in pixels (2x original): 512, 448
    //Window size in blocks: 16, 14
    
    //Blocks Mario can move before screen moves with him: 7
    
    /* TO DO LIST:
    √ Item block
      - Animation af item block
    √ Brick block
    √ Mushroom
    √ Stor mario
    √ Mario death
    - Menu
    - Flag pole
    √ Pipes
    - Have underground i slutningen af banen
    √ Musik
      √ Sound FX
    √ Background Polish
    √ indsæt leveldesign
    */
    
    loadSprites(0);
    size(512,448);
    frameRate(60);
    noStroke();
    stroke(2);
    rectMode(CORNER);
    imageMode(CENTER);
    

    mainTheme.play();
    
    mainFont = loadFont("Super-Mario-Bros.-NES-48.vlw");
    textFont(mainFont,14); //Double the height of the original
    LevelSetup = new LevelSetup();
    LevelSetup.loadScene(0);
    
    //Spawn Player
    Player = new Player(500, 400);
    Player.animationSetup();
    
    
    for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every blockInstance. Checks every possible tablecell. 
    if(goombaInstances[i]!=null) {
      goombaInstances[i].animationSetup();
    }
  }
}

void draw(){
  deltaTimeCalculation();
  
  
  switch(gameState){
    case 0:
      background(backgroundColor);
      
      for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every blockInstance. Checks every possible tablecell. 
        if(backgroundInstances[i]!=null) backgroundInstances[i].Display();
        
        if(menuInstances[i]!=null) menuInstances[i].Active();
        
        if(blockInstances[i]!=null) blockInstances[i].Display();
      
        if(goombaInstances[i]!=null) goombaInstances[i].Alive();
      
        if(collectibleInstances[i]!=null) collectibleInstances[i].Alive();  
      }
      Player.PlayerActive();
    break;
    
    case 1:
      background(backgroundColor);
      if(frameCountWhenLoadingStarted + 180 > frameCount){
        for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every blockInstance. Checks every possible tablecell.   
          if(menuInstances[i]!=null){
            menuInstances[i].Active();
          }
        }
      } else {
        //LOAD NEXT LEVEL
        LevelSetup.loadScene(LevelSetup.currentLevel); //Load the level
        timeLeft = 400;
        for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every blockInstance. Checks every possible tablecell. 
          if(goombaInstances[i]!=null) {
          goombaInstances[i].animationSetup();
          }
        }
        Player.animationSetup();
        gameState = 2; //Change the game state accordingly, so that the player has control over the player
        millisAtStartOfLevel = millis(); //Reset timer for the level
      }
    break;
    
    
    case 2:
      if (timeLeft > 0) //If there is time left, subtract time accordingly from the timer.
        timeLeft = 400 - (millis()-millisAtStartOfLevel)/1000;
      else { //If there is no time left, kill the player
        Player.Death();
      }
      
      background(backgroundColor);
      if (millis()%1000==0) timeLeft--;
      for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every blockInstance. Checks every possible tablecell. 
      if(backgroundInstances[i]!=null) backgroundInstances[i].Display();
      }
      
      for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every blockInstance. Checks every possible tablecell. 
        
        if(menuInstances[i]!=null) menuInstances[i].Active();
        
        if(blockInstances[i]!=null) blockInstances[i].Display();
      
        if(goombaInstances[i]!=null) goombaInstances[i].Alive();
      
        if(collectibleInstances[i]!=null) collectibleInstances[i].Alive();
      }
      Player.PlayerActive();
      
      if(keyPressed && key == 'b'){
        LevelSetup.currentLevel++;
        LevelSetup.loadScene(LevelSetup.currentLevel);
        println("Scene" + LevelSetup.currentLevel + "Loaded");
        delay(100);
    }
    if(keyPressed && key == 'c') LevelSetup.currentLevel += 1;
  }
}

void startLoadingScene(){ //Go to the loading level scene
  gameState = 1;
  LevelSetup.currentLevel += 1;
  LevelSetup.loadScene(-1); //Load the load-level scene
  frameCountWhenLoadingStarted = frameCount; //Used for the amount of frames the loading scene should be displayed
}


void deltaTimeCalculation(){
  prevTime = currentTime;
  currentTime = millis();
  deltaTime = (currentTime - prevTime)/20;
}

void loadSprites(int palette){ //Change sprite pallete based on loaded level
switch(palette){
  case 0: //Palette 0
    backgroundColor = #aed1ee;
    groundSprite = loadImage("Sprite_Ground.png");
    itemSprite = loadImage("Sprite_Item.png");
    itemSpriteEmpty = loadImage("Sprite_ItemEmpty.png");
    brickSprite = loadImage("Sprite_Brick.png");
    stoneSprite = loadImage("Sprite_Stone.png");
    spriteSheetGoomba = loadImage("SpriteSheet_Goomba.png");
    break;
    
  case 1: //Palette 1
    backgroundColor = 0;
    groundSprite = loadImage("Sprite_UGGround.png");
    itemSprite = loadImage("Sprite_UGItem.png");
    itemSpriteEmpty = loadImage("Sprite_UGItemEmpty.png");
    brickSprite = loadImage("Sprite_UGBrick.png");
    stoneSprite = loadImage("Sprite_UGStone.png");
    spriteSheetGoomba = loadImage("SpriteSheet_UGGoomba.png");
  break;
}
    
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
