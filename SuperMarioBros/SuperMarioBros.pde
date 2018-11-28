//Alsing2
LevelSetup LevelSetup;
Ground Ground;

void setup(){
    //Level size in pixels: 7042,448
    //Level size in blocks: 221, 14

    //Window size in blocks: 16, 14
    //Window size in pixels (2x original): 512, 448
    
    size(512,448);
    noStroke();
    LevelSetup = new LevelSetup();
    LevelSetup.loadScene(1);

}
void draw(){
  if(keyPressed && key == 'b'){
  background(0);
  LevelSetup.loadScene(2);
  println("tesst2");
  }
}
