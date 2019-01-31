//Alsing4
LevelSetup LevelSetup;;
Ground Ground; //Declare object Ground
Ground[] groundInstances; //Create a array of name groundInstances, containing instances of the Ground class.
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
    LevelSetup = new LevelSetup();
    LevelSetup.loadScene(1);
    
    //Spawn Player
    Player = new Player(100,100);
    
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
  
  
  Background.Display(100,100,255);
    
  for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every groundInstance. Checks every possible tablecell. 
    if(groundInstances[i]!=null) groundInstances[i].Display();
  }
  Player.Movement();
  Player.Display();
}

void deltaTimeCalculation(){
  prevTime = currentTime;
  currentTime = millis();
  deltaTime = (currentTime - prevTime)/20;
}
