//Alsing4
LevelSetup LevelSetup;;
Ground Ground; //Declare object Ground
Ground[] groundInstances; //Create a array of name groundInstances, containing instances of the Ground class.
Player Player;
Background Background;

void setup(){
  
    //60 FPS
    //Level size in pixels: 7042,448
    //Level size in blocks: 221, 14

    //Window size in pixels (2x original): 512, 448
    //Window size in blocks: 16, 14
    
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
  if(keyPressed && key == 'b'){
  LevelSetup.loadScene(2);
  println("Scene 2 Loaded");
  }
  
  Background.Display(1,1,1);
  
  if(keyPressed && keyCode == RIGHT){
  Player.MoveRight();
  }
  
  for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every groundInstance. Checks every possible tablecell. 
    if(groundInstances[i]!=null) groundInstances[i].Display();
  }
  Player.Display();
}
