class LevelSetup{
    public int currentLevel=1;
    public int currentTableCellCount;
    Table currentLevelTable;
    int currentIdentifier;
     
    LevelSetup(){
    }
    
    void loadScene (int inputScene){
      currentLevel = inputScene;
      currentLevelTable = loadTable("scene"+inputScene+".csv");
      currentTableCellCount = currentLevelTable.getColumnCount()*currentLevelTable.getRowCount();
      blockInstances = new Block[currentTableCellCount]; //Initiliasizes array and sets length to amount of cells in current level
      goombaInstances = new Goomba[currentTableCellCount]; //Initiliasizes array and sets length to amount of cells in current level

            for (int t=0; t<(currentLevelTable.getColumnCount()*currentLevelTable.getRowCount()); t++){ 
              currentIdentifier = currentLevelTable.getInt(t/currentLevelTable.getColumnCount(),t%currentLevelTable.getColumnCount());
              if(currentIdentifier!=0 && (currentIdentifier<20 || currentIdentifier>29)){ //If there is a block in the cell which the for-loop has reached, which also isn't an enemy, then spawn a new block
              blockInstances[t] = new Block(t%currentLevelTable.getColumnCount()*32,t/currentLevelTable.getColumnCount()*32,currentLevelTable.getInt(t/currentLevelTable.getColumnCount(),t%currentLevelTable.getColumnCount()));
              } else { //Spawn Enemy
                switch (currentIdentifier){
                  case 20:
                  goombaInstances[t] = new Goomba(t%currentLevelTable.getColumnCount()*32,t/currentLevelTable.getColumnCount()*32);
                  break;
                  
                  case 21:
                  break;
                  case 22:
                  break;
                }
              } 
              
            }
            
    }
}
