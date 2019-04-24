//Yellow #FFEA6C
//Green #83FF71

LevelSetup LevelSetup;;
Block Ground; //Declare object Block
Block[] blockInstances; //Create a array of name blockInstances, containing instances of the Block class.
Player Player;
Background Background;
float currentTime;
float prevTime;
float deltaTime;

void setup(){
    //60 FPS
    //Level size in pixels: 7042,448
    //Level size in blocks: 221, 14

    //Window size in pixels (2x original): 512, 448
    //Window size in blocks: 16, 14
    
    //Blocks Mario can move before screen moves with him: 7
    
    size(512,448);
    frameRate(60);
    noStroke();
    stroke(2);
    rectMode(CORNER);
    imageMode(CENTER);
    LevelSetup = new LevelSetup();
    LevelSetup.loadScene(3);
    
    //Spawn Player
    Player = new Player(230, 0);
    Player.animationSetup();
    
    Background = new Background();
    

}
void draw(){
  deltaTimeCalculation();
  
  if(keyPressed && key == 'b'){
    LevelSetup.currentLevel++;
    LevelSetup.loadScene(LevelSetup.currentLevel);
    println("Scene" + LevelSetup.currentLevel + "Loaded");
    delay(100);
  }
  
  
  Background.Display(#AED1EE);
    Player.Movement();
  Player.Display();
  for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every blockInstance. Checks every possible tablecell. 
    if(blockInstances[i]!=null && Player.scroll) blockInstances[i].Scroll();
    if(blockInstances[i]!=null) blockInstances[i].Display();
  }

}

void deltaTimeCalculation(){
  prevTime = currentTime;
  currentTime = millis();
  deltaTime = (currentTime - prevTime)/20;
}
