LevelSetup LevelSetup;
Block Ground; //Declare object Block
Block[] blockInstances; //Create a array of name blockInstances, containing instances of the Block class.
Goomba Goomba;
Goomba[] goombaInstances;
Player Player;
Background Background;
Mushroom Mushroom;
Mushroom[] mushroomInstances;
Menu Menu;
Menu[] menuInstances;
PFont mainFont;
float scrollAmount;
float currentTime;
float prevTime;
float deltaTime;
float frameCountWhenLoadingStarted;
int gameState; //Responsible for the state of the game - 0: Main menu 1: LevelLoad 2: Gameplay 3:Paused Gameplay
int mushroomIdentifier = 0; //For creating mushrooms with seperate names
int publicPipeIdentifier = 0; //For creating ID for pipes which can be used by Mario. 
int[] pipeArray = new int[100]; //Initiliasizes array and sets length to 100 - setting a max of 50 pipes per level


void setup(){
    //60 FPS
    //Level size in pixels: 7042,448
    //Level size in blocks: 221, 14

    //Window size in pixels (2x original): 512, 448
    //Window size in blocks: 16, 14
    
    //Blocks Mario can move before screen moves with him: 7
    
    /* TO DO LIST:
    - Item block
      - Animation af item block
    - Brick block
    √ Mushroom
    √ Stor mario
    - Mario death
    - Menu
    - Flag pole
    √ Pipes
    - Have underground i slutningen af banen
    - Musik
    - Background Polish
    - indsæt leveldesign
    */
    
    size(512,448);
    frameRate(60);
    noStroke();
    stroke(2);
    rectMode(CORNER);
    imageMode(CENTER);
    mainFont = loadFont("Super-Mario-Bros.-NES-48.vlw");
    textFont(mainFont,14); //Double the height of the original
    LevelSetup = new LevelSetup();
    LevelSetup.loadScene(0);
    
    //Spawn Player
    Player = new Player(230, 0);
    Player.animationSetup();
    
    Background = new Background();
    
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
      Background.Display(#AED1EE);
      Player.PlayerActive();
      for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every blockInstance. Checks every possible tablecell. 
        if(blockInstances[i]!=null) blockInstances[i].Display();
      
        if(goombaInstances[i]!=null) {
          goombaInstances[i].Alive();
        }
      
        if(mushroomInstances[i]!=null){
          mushroomInstances[i].Alive();
        }
        
        if(menuInstances[i]!=null){
          menuInstances[i].Alive();
        }
      }
    break;
    
    case 1:
    println("case 1");
      Background.Display(#AED1EE);
    if(frameCountWhenLoadingStarted < frameCount +200){
      for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every blockInstance. Checks every possible tablecell.   
        if(menuInstances[i]!=null){
          menuInstances[i].Alive();
        }
      }
    } else {
      LevelSetup.loadScene(LevelSetup.currentLevel); //Load the level
      gameState = 2; //Change the game state accordingly, so that the player has control over the player
    }
      
      
      
    
    break;
    
    
    case 2:
      Player.PlayerActive();
      for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every blockInstance. Checks every possible tablecell. 
        if(menuInstances[i]!=null) menuInstances[i].Alive();
        
        if(blockInstances[i]!=null) blockInstances[i].Display();
      
        if(goombaInstances[i]!=null) goombaInstances[i].Alive();
      
        if(mushroomInstances[i]!=null) mushroomInstances[i].Alive();
      }
      
      if(keyPressed && key == 'b'){
        LevelSetup.currentLevel++;
        LevelSetup.loadScene(LevelSetup.currentLevel);
        println("Scene" + LevelSetup.currentLevel + "Loaded");
        delay(100);
    }
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
