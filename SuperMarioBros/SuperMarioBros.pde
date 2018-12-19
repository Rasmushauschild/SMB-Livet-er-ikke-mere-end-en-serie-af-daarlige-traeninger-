//Alsing3
LevelSetup LevelSetup;
Ground Ground; //Declare object Ground
Ground[] groundInstances; //Create a array of name groundInstances, containing instances of the Ground class.

Player Player;

void setup(){
    groundInstances = new Ground[1000]; //Initiliasizes array and sets length to 1000
  
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
    Player = new Player(100,20);
    

}
void draw(){
  if(keyPressed && key == 'b'){
  background(0);
  LevelSetup.loadScene(2);
  println("Scene 2 Loaded");
  }
  
  if(keyPressed && keyCode == RIGHT){
  Player.MoveRight();
  }
  
  
  Player.Display();
  
  for (int i = 0; i<1000;i++){
  groundInstances[i].Display();
  }
}
