class LevelSetup{
    public int currentLevel=1;
    public int currentTableCellCount;
    Table currentLevelTable;
     
    LevelSetup(){
    }
    
    void loadScene (int inputScene){
      currentLevel = inputScene;
      currentLevelTable = loadTable("scene"+inputScene+".csv");
      currentTableCellCount = currentLevelTable.getColumnCount()*currentLevelTable.getRowCount();
      groundInstances = new Ground[currentTableCellCount]; //Initiliasizes array and sets length to amount of cells in current level

            //println(currentLevelTable.getInt(13, 1));
            
            for (int t=0; t<(currentLevelTable.getColumnCount()*currentLevelTable.getRowCount()); t++){ 
              //print(currentLevelTable.getInt(t/currentLevelTable.getRowCount(),t%currentLevelTable.getColumnCount()));
              //println(t/currentLevelTable.getRowCount(),t%currentLevelTable.getColumnCount());
              
              switch (currentLevelTable.getInt(t/currentLevelTable.getColumnCount(),t%currentLevelTable.getColumnCount())){
                case 1:

                break;
                
                case 2:
                
                groundInstances[t] = new Ground(t%currentLevelTable.getColumnCount()*32,t/currentLevelTable.getColumnCount()*32);
                break;
                
              }
              
              //println(currentLevelTable.getColumnCount()*currentLevelTable.getRowCount());
              //println(currentLevelTable.getInt(13,1));
            }
            
    }
}
