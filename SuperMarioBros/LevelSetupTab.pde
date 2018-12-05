class LevelSetup{
    public int currentLevel=1;
    Table currentLevelTable;
     
    LevelSetup(){
    }
    
    void loadScene (int inputScene){
      currentLevel = inputScene;
      currentLevelTable = loadTable("scene"+inputScene+".csv");
            //println(currentLevelTable.getInt(13, 1));
            
            for (int t=0; t<(currentLevelTable.getColumnCount()*currentLevelTable.getRowCount()); t++){ 
              //print(currentLevelTable.getInt(t/currentLevelTable.getRowCount(),t%currentLevelTable.getColumnCount()));
              //println(t/currentLevelTable.getRowCount(),t%currentLevelTable.getColumnCount());
              
              switch (currentLevelTable.getInt(t/currentLevelTable.getColumnCount(),t%currentLevelTable.getColumnCount())){
                case 1:
                fill(0,70,180);
                rect((t%currentLevelTable.getColumnCount())*32,t/currentLevelTable.getColumnCount()*32,32,32);
                break;
                
                case 2:
                Ground = new Ground(t%currentLevelTable.getColumnCount()*32,t/currentLevelTable.getColumnCount()*32);
                break;
                
              }
              
              //println(currentLevelTable.getColumnCount()*currentLevelTable.getRowCount());
              //println(currentLevelTable.getInt(13,1));
            }
            
    }
}
