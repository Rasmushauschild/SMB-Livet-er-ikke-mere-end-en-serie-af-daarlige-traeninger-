//Yellow #FFEA6C
//Green #83FF71

LevelSetup LevelSetup;;
Ground Ground; //Declare object Ground
Ground[] groundInstances; //Create a array of name groundInstances, containing instances of the Ground class.
Player Player;
Background Background;
float currentTime;
float prevTime;
float deltaTime;
int animCount;
PImage spriteSheetSmallMario;
PImage[] spritesSmallMario = new PImage[13]; //Creates an empty PImage array with the correct length

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
    LevelSetup.loadScene(1);
    animCount = 14;
    spriteSheetSmallMario = loadImage("SpriteSheet_SmallMario.png"); //Loads the spritesheet
    
    int W = spriteSheetSmallMario.width/animCount;
    
    for(int i = 0; i<spritesSmallMario.length; i++){
    int x = i%animCount*W;
    spritesSmallMario[i]=spriteSheetSmallMario.get(x,0,W,spriteSheetSmallMario.height);
    }
    
    //Spawn Player
    Player = new Player(230, 0);
    
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
  for (int i = 0; i<LevelSetup.currentTableCellCount;i++){ //For-loop for displaying every groundInstance. Checks every possible tablecell. 
    if(groundInstances[i]!=null && Player.scroll) groundInstances[i].Scroll();
    if(groundInstances[i]!=null) groundInstances[i].Display();
  }

}

void deltaTimeCalculation(){
  prevTime = currentTime;
  currentTime = millis();
  deltaTime = (currentTime - prevTime)/20;
}
