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
      blockInstances = new Block[currentTableCellCount]; //Initiliasizes array and sets length to amount of cells in current level

            for (int t=0; t<(currentLevelTable.getColumnCount()*currentLevelTable.getRowCount()); t++){ 
              if(currentLevelTable.getInt(t/currentLevelTable.getColumnCount(),t%currentLevelTable.getColumnCount())!=0){ //If there is a block in the cell which the for-loop has reached, then spawn a new block
              blockInstances[t] = new Block(t%currentLevelTable.getColumnCount()*32,t/currentLevelTable.getColumnCount()*32,currentLevelTable.getInt(t/currentLevelTable.getColumnCount(),t%currentLevelTable.getColumnCount()));
              }
            }
            
    }
}
