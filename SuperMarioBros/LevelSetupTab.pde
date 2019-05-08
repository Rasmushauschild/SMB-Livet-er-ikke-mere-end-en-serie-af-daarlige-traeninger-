class LevelSetup{
    public int currentLevel;
    public int currentTableCellCount;
    Table currentLevelTable;
    int currentIdentifier;
     
    LevelSetup(){
    }
    
    void loadScene (int inputScene){
      currentLevelTable = loadTable("scene"+inputScene+".csv");
      currentTableCellCount = currentLevelTable.getColumnCount()*currentLevelTable.getRowCount();
      blockInstances = new Block[currentTableCellCount]; //Initiliasizes array and sets length to amount of cells in current level
      goombaInstances = new Goomba[currentTableCellCount]; //Initiliasizes array and sets length to amount of cells in current level
      collectibleInstances = new Collectible[currentTableCellCount*currentTableCellCount];
      menuInstances = new Menu[currentTableCellCount];
      backgroundInstances = new Background[currentTableCellCount];
      int time = millis();
     
            for (int t=0; t<(currentTableCellCount); t++){ 
              currentIdentifier = currentLevelTable.getInt(t/currentLevelTable.getColumnCount(),t%currentLevelTable.getColumnCount());
              if (currentIdentifier!=0 && (currentIdentifier<18 || currentIdentifier>50)){ //If there is a block in the cell which the for-loop has reached, which also isn't an enemy or menu UI, then spawn a new block
                blockInstances[t] = new Block(t%currentLevelTable.getColumnCount()*32,t/currentLevelTable.getColumnCount()*32,currentIdentifier,t);
              } else if (currentIdentifier == 20){ //Spawn Goomba
                goombaInstances[t] = new Goomba(t%currentLevelTable.getColumnCount()*32,t/currentLevelTable.getColumnCount()*32);
              } else if (currentIdentifier == 19 || currentIdentifier == 18){ //Spawn Coin
                collectibleInstances[t] = new Collectible(t%currentLevelTable.getColumnCount()*32,t/currentLevelTable.getColumnCount()*32,currentIdentifier);
                collectibleIdentifier = t; //Ensures there are no duplicates in collectibles spawned later in the game.
                println(collectibleIdentifier);
              } else if (currentIdentifier >= 30 && currentIdentifier < 40){ //Spawn a menu-object
                menuInstances[t] = new Menu(t%currentLevelTable.getColumnCount()*32,t/currentLevelTable.getColumnCount()*32,currentIdentifier);
              } else if (currentIdentifier >= 40 && currentIdentifier < 50){
                backgroundInstances[t] = new Background(t%currentLevelTable.getColumnCount()*32,t/currentLevelTable.getColumnCount()*32,currentIdentifier);
              }
            }

        println("loadtime ", millis()-time );   
            
    }
}
