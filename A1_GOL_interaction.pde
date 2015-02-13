// www.openprocessing.org/user/46418
// Ross Lagoy
// Lab3, BCB 502
// 02/12/15     Game Of Life v2.0

import controlP5.*;
ControlP5 cp5;
ColorPicker cp;
DropdownList d1;
ControlTimer c;
Textlabel t;
int cnt = 0;

PFont f; // For font
float[] aliveVals; // Initiate live cell array for the time plot
float[] deadVals; // Initiate dead cell array for the time plot
float[] infectedVals; // Initiate infected cell array for the time plot

// Size of cells
int cellSize = 10;
//int width = 900;
int cellHeight = 300;
int rate = 30;

// How likely for a cell to be alive at start (in percentage)
float startProbability = 50;

// Variables for timer
int interval = 100;
int lastRecordedTime = 0;

// Colors for active/inactive cells
color dead = color(60);
color infection = color(255, 165, 0);

// Array of cells
int[][] cells; 
// Buffer to record the state of the cells and use this while changing the others in the interations
int[][] cellsBuffer; 

// Pause
boolean pause = false;

void setup() {
  size (900, 800); // Size of canvas

  // Instantiate arrays for cells to migrate 
  cells = new int[width/cellSize][cellHeight/cellSize];
  cellsBuffer = new int[width/cellSize][cellHeight/cellSize];

  // This will draw the background grid
  stroke(0);
  noSmooth();

  // Initialization of cells in the grid
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<cellHeight/cellSize; y++) {
      float state = random (100);
      if (state > startProbability) { 
        state = 0;
      } else {
        state = 1;
      } 
      cells[x][y] = int(state); // Save state of each cell
    }
  }

  f = createFont("Arial", 14, true); // Arial, 16 point, anti-aliasing on 

  cp5 = new ControlP5(this);
  c = new ControlTimer();
  t = new Textlabel(cp5, "--", 100, 100);
  c.setSpeedOfTime(1);

  cp = cp5.addColorPicker("")
    .setPosition(620, 330)
      .setSize(0, 0)
        .setColorValue(color(58, 108, 168, 200))
          ;
  // create a DropdownList
  d1 = cp5.addDropdownList("Type of infection")
    .setPosition(620, 460)
      .setSize(260, 70)
        ;
  customize(d1); // customize the first list
  d1.setIndex(10);

  // Instantiate cell vs. time array for 'real-time cell viability' plot
  aliveVals = new float[590];
  for (int i = 0; i < aliveVals.length; i++) {
    aliveVals[i] = 1;
  }
  deadVals = new float[590];
  for (int i = 0; i < deadVals.length; i++) {
    deadVals[i] = 1;
  }
  infectedVals = new float[590];
  for (int i = 0; i < infectedVals.length; i++) {
    infectedVals[i] = 1;
  }
}

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(cp.getColorValue()));
  ddl.setItemHeight(10);
  ddl.setBarHeight(30);
  ddl.captionLabel().style().marginTop = 10;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
  ddl.addItem("bacterial", 1);
  ddl.addItem("airborne", 1);
  ddl.addItem("Fungal", 1);
  ddl.addItem("Protozoal", 1);
  ddl.addItem("viral", 1);
  ddl.addItem("immune", 1);
  ddl.scroll(10);
  ddl.setColorBackground(color(60));
}

void controlEvent(ControlEvent c) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  //  if (theEvent.isGroup()) {
  //    // check if the Event was triggered from a ControlGroup
  //    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  //  } else if (theEvent.isController()) {
  //    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  //  }

  // when a value change from a ColorPicker is received, extract the ARGB values
  // from the controller's array value
  if (c.isFrom(cp)) {
    int r = int(c.getArrayValue(0));
    int g = int(c.getArrayValue(1));
    int b = int(c.getArrayValue(2));
    int a = int(c.getArrayValue(3));
    // color col = color(r,g,b,a);
    println("event\talpha:"+a+"\tred:"+r+"\tgreen:"+g+"\tblue:"+b); // +"\tcol"+col
  }
}

void draw() {
  background(0); // Set background to black

  // Plot cell viability line graphs
  for (int i = 0; i < deadVals.length-1; i++) {
    stroke(dead);
    strokeWeight(2);
    line(i, 780-(deadVals[i]/3), i+1, 780-(deadVals[i+1]/3));
    if (i < 10) {
      stroke(0);
    }
  }
  for (int i = 0; i < aliveVals.length-1; i++) {
    stroke(cp.getColorValue());
    strokeWeight(2);
    line(i, 780-(aliveVals[i]/3), i+1, 780-(aliveVals[i+1]/3));
  }
  for (int i = 0; i < infectedVals.length-1; i++) {
    stroke(infection);
    strokeWeight(2);
    line(i, 780-(infectedVals[i]/3), i+1, 780-(infectedVals[i+1]/3));
  }

  frameRate(rate); // Change the frame rate based on user input

  t.setValue(c.toString());
  t.draw(this);
  t.setPosition(535, 787);

  stroke(255);
  strokeWeight(1);

  // Draw slider backgrounds
  fill(60);
  rect(320, 340, 270, 30);
  rect(320, 430, 270, 30);
  rect(320, 520, 270, 30);

  // Begin number of cell type count
  int aliveCount = 0;
  int deadCount = 0;
  int infectedCount = 0;

  // Plot cell viability bar graphs
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<cellHeight/cellSize; y++) {
      if (cells[x][y] == 1) {
        fill(cp.getColorValue());
        float numberAlive = aliveCount++;
        rect(320, 340, numberAlive/10, 30);
        aliveVals[aliveVals.length-1] = numberAlive/5;
      }
      if (cells[x][y] == 0) {
        fill(100);
        float numberDead = deadCount++;
        rect(320, 430, numberDead/10, 30);
        deadVals[deadVals.length-1] = numberDead/5;
      }
      if (cells[x][y] == 2) {
        fill(infection);
        float numberInfected = infectedCount++;
        rect(320, 520, numberInfected/10, 30);
        infectedVals[infectedVals.length-1] = numberInfected/5;
      }
    }
  }

  // Draw the line graph grid
  strokeWeight(2);
  stroke(70);
  line(0, 780, 590, 780);
  strokeWeight(0.25);
  line(0, 600, 590, 600);
  line(0, 687, 590, 687);
  
  strokeWeight(2);
  stroke(70);
  line(620, 780, 875, 780);
  strokeWeight(0.25);
  line(620, 600, 875, 600);
  line(620, 687, 875, 687);

  // Draw canvas labels
  smooth();
  textFont(f, 14);
  fill(255);
  //text("Real-time cell viability:", 20, 580);
  textFont(f, 11);
  text("100%", 5, 595);
  text("50%", 5, 682);
  text("0%", 5, 775);
  text("time:", 510, 795);
  
  // Other graph
  textFont(f, 14);
  //text("Subset real-time cell viability:", 640, 580);
  textFont(f, 11);
  text("100%", 625, 595);
  text("50%", 625, 682);
  text("0%", 625, 775);
  textFont(f, 11);
  text("time:", 780, 795);

  textFont(f, 14);
  text("Percentage of live cells", 300, 330);
  text("Percentage of dead cells", 300, 420);
  text("Percentage of infected cells", 300, 510);

  text("The Game of Life Rules:", 20, 330);
  
  text("Click the grid create an infection", 30, 360);
  text("Can you cure the infection?!", 30, 390);
  
  text("Pause:", 30, 440);
  text("P", 220, 440);
  text("Restart:", 30, 470);
  text("R", 220, 470);
  
  text("Clear:", 30, 520);
  text("C", 220, 520);
  text("Framerate:", 30, 550);
  text("A (-), D (+)", 220, 550);
  
  noSmooth();
  strokeWeight(0);
  stroke(60);

  //Draw grid for the cells
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<cellHeight/cellSize; y++) {
      if (cells[x][y]==1) {
        fill(cp.getColorValue()); // If alive
      } else if (cells[x][y]==2) {
        fill(infection); //If infected
      } else {
        fill(dead); // If dead
      }
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }

  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }

  // Create  new cells manually on pause
  if (mousePressed && mouseY < 300) {

    // Map and avoid out of bound errors
    int xCellOver = int(map(mouseX, 0, width, 0, width/cellSize));
    xCellOver = constrain(xCellOver, 0, width/cellSize-1);
    int yCellOver = int(map(mouseY, 0, cellHeight, 0, cellHeight/cellSize));
    yCellOver = constrain(yCellOver, 0, cellHeight/cellSize-1);

    // Check against cells in buffer
    if (cellsBuffer[xCellOver][yCellOver]==0) { // Cell is alive
      cells[xCellOver][yCellOver]=2; // Infect
      fill(infection); // Fill with infection color
    } else { // Cell is dead
      cells[xCellOver][yCellOver]=1; // Make dead
      fill(dead); // Fill with dead color
    }
  } else if (!mousePressed ) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<cellHeight/cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
}

void iteration() { // When the clock ticks

  noStroke();

  // Slide everything down in the array for the line graphs
  for (int i = 0; i < deadVals.length-1; i++) {
    deadVals[i] = deadVals[i+1];
  }
  for (int i = 0; i < aliveVals.length-1; i++) {
    aliveVals[i] = aliveVals[i+1];
  }
  for (int i = 0; i < infectedVals.length-1; i++) {
    infectedVals[i] = infectedVals[i+1];
  }

  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<cellHeight/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
      if (cells[x][y] == 1) {
        fill(cp.getColorValue());
      }
      if (cells[x][y] == 0) {
        fill(dead);
      }
      if (cells[x][y] == 2) {
        fill(infection);
      }
    }
  }

  // Visit each cell
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<cellHeight/cellSize; y++) {

      // And visit all the neighbors of each cell
      int healthyNeighbours = 0; // Start to count the healthy neighbors
      int infectedNeighbours = 0; // Start to count the infected neighbors
      int deadNeighbours = 0; // Start to count the dead neighbors
      for (int xx=x-1; xx<=x+1; xx++) {
        for (int yy=y-1; yy<=y+1; yy++) {  
          if (((xx>=0)&&(xx<width/cellSize))&&((yy>=0)&&(yy<cellHeight/cellSize))) { // Make sure you are not out of bounds
            if (!((xx==x)&&(yy==y))) { // Make sure to to check against self
              if (cellsBuffer[xx][yy]==1) {
                healthyNeighbours ++; // Check healthy alive neighbors and count them
              }
              if (cellsBuffer[xx][yy]==2) {
                infectedNeighbours ++; // Check infected alive neighbors and count them
              }
              if (cellsBuffer[xx][yy]==0) {
                deadNeighbours ++; // Check dead neighbors and count them
              }
            } // End of if
          } // End of if
        } // End of yy loop
      } //End of xx loop

      // Apply rules
      if (cellsBuffer[x][y]==1) { // The cell is alive, kill it if necessary
        if (healthyNeighbours < 2 || healthyNeighbours > 3) {
          cells[x][y] = 0; // Die unless it has 2 or 3 neighbors
        }
        if (infectedNeighbours >= 1) { // A neighbor is infected, take over healthy population
          cells[x][y] = 2;
        }
      } else { // The cell is dead, make it live if necessary      
        if (healthyNeighbours == 3) {
          cells[x][y] = 1; // Only if it has 3 neighbours
        }
      }
      if (cellsBuffer[x][y]==2) {
        if (infectedNeighbours < 2 || infectedNeighbours > 3) {
          cells[x][y] = 0; // Die unless it has 2 or 3 neighbors
        }
      } else { // The cell is dead, make it infected if necessary      
        if (infectedNeighbours == 3) {
          cells[x][y] = 2; // Only if it has 3 neighbors
        }
      }
    } // End of y loop
  } // End of x loop
} // End of function

// Apply user interaction by key press commands
void keyPressed() {
  if (key=='r' || key == 'R') {
    // Restart reinitialization of cells
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<cellHeight/cellSize; y++) {
        float state = random (100);
        if (state > startProbability) {
          state = 0;
        } else {
          state = 1;
        }
        cells[x][y] = int(state); // Save state of each cell
      }
    }
  }
  if (key=='p') { // On/off of pause
    pause = !pause;
  }
  if (key=='d') { // Increase framerate
    rate++;
  }
  if (key=='a') { // Decrease framerate
    rate--;
  }
  if (key=='c' || key == 'C') { // Clear all
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<cellHeight/cellSize; y++) {
        cells[x][y] = 0; // Save all to zero
      }
    }
  }
}
