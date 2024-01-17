// extend the Matrix class since we need to override the Matrix's sequencer
class CustomMatrix extends Matrix {

  // add a list to store some presets
  ArrayList<int[][]> presets = new ArrayList<int[][]>();
  int currentPreset = 0;
  
  Thread update;
  
  CustomMatrix(ControlP5 cp5, String theName) {
    super(cp5, theName);
    stop(); // stop the default sequencer and
    // create our custom sequencer thread. Here we 
    // check if the sequencer has reached the end and if so
    // we updated to the next preset.
    //update = new Thread(theName) {
    // public void run( ) {
    //   while ( true ) {
    //     cnt++;
    //     cnt %= _myCellX;
    //     if (cnt==0) {
    //       // we reached the end and go back to start and 
    //       // update the preset 
    //       next();
    //     }
    //     trigger(cnt);
    //     try {
    //       sleep( _myInterval );
    //     } 
    //     catch ( InterruptedException e ) {
    //     }
    //   }
    // }
    //};
    //update.start();
  }
  
   public void run( ) {     
        cnt++;
        cnt %= _myCellX;
        if (cnt==0) {
          // we reached the end and go back to start and 
          // update the preset 
          //next();
        }
        trigger(cnt);
        println(cnt);
   }


  void next() {
    currentPreset++;
    currentPreset %= presets.size();
    setCells(presets.get(currentPreset));
  }

  // initialize some random presets.
  void initPresets() {
    for (int i=0; i<4; i++) {
      presets.add(createPreset(_myCellX, _myCellY));
    }
    setCells(presets.get(0));
  }

  // create a random preset
  int[][] createPreset(int theX, int theY) {
    int[][] preset = new int[theX][theY];
    for (int x=0; x<theX; x++) {
      for (int y=0; y<theY; y++) {
        preset[x][y] = random(1)>0.5 ? 1:0;
      }
    }
    return preset;
  }
}