class LevelSetup{
    int levelCount=1;
    Table currentLevel;
     
    LevelSetup(){
    }
    
    void loadScene (int inputScene){
            currentLevel = loadTable("scene"+inputScene+".csv");
            //println(currentLevel.getInt(13, 1));
            
            for (int t=0; t<(currentLevel.getColumnCount()*currentLevel.getRowCount()); t++){ 
              //print(currentLevel.getInt(t/currentLevel.getRowCount(),t%currentLevel.getColumnCount()));
              //println(t/currentLevel.getRowCount(),t%currentLevel.getColumnCount());
              
              switch (currentLevel.getInt(t/currentLevel.getColumnCount(),t%currentLevel.getColumnCount())){
                case 1:
                fill(0,70,180);
                rect((t%currentLevel.getColumnCount())*32,t/currentLevel.getColumnCount()*32,32,32);
                break;
                
                case 2:
                Ground = new Ground(t%currentLevel.getColumnCount()*32,t/currentLevel.getColumnCount()*32);
                break;
                
              }
              
              //println(currentLevel.getColumnCount()*currentLevel.getRowCount());
              //println(currentLevel.getInt(13,1));
            }
            
    }
}
