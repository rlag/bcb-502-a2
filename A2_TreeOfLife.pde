// www.openprocessing.org/user/46418
// Ross Lagoy
// A2, BCB 502
// 02/12/15

// Sets global variables
Table table, converted, distances;
PrintWriter write, print, output;
PFont f; // For font
PImage img; // For TreeOfLife image (so you don't need to run it in R)

void setup() {
  size(1400, 800);
  img = loadImage("TreeOfLife.png"); // load R generated tree, prior rotated 90deg, w/900, h/750

  Table table = loadTable("zoo.data.csv"); // load raw zoo data

  int columns = table.getColumnCount(); // column variable
  int rows = table.getRowCount(); // row variable
  println(rows, columns); // check expected dimensions

  write = createWriter("converted.csv"); // begin to write to file

  // Compare animal row 1 and each column with eachother across all rows (animals)
  // if int = int (true=true, false=false), add 1, if not, add 0.
  // This will calculate "distance" between animals.
  for (int k = 0; k < rows; k++) {
    for (int i = 0; i < rows; i++) {
      for (int j = 1; j < columns-1; j++) {
        if (table.getInt(k, j) == table.getInt(i, j)) {
          int match = 0;
          write.println(table.getInt(k, j) + "," + table.getInt(i, j) + "," + match);
        } else {
          int noMatch = 1;
          write.println(table.getInt(k, j) + "," + table.getInt(i, j) + "," + noMatch);
        }
      }
    }
    write.flush();
  }
  write.close();
  Table converted = loadTable("converted.csv"); // load file for next sequence
  println(converted.getRowCount(), converted.getColumnCount()); // check expected dimensions

  // Calculate distances based on animal to animal comparison for all animals
  print = createWriter("distances.csv"); // begin writing to file
  int n = 0;
  int j = 1;
  int start = 0;
  for (int i = n; i < converted.getRowCount (); i++) {
    start = start + converted.getInt(i, 2);
    if (i == (16*j)-1) {
      print.print(start+",");
      j++;
      n = i;
      start = 0;
    }
    print.flush();
  }
  print.close();
  Table distances = loadTable("distances.csv"); // load file for next sequence
  println(distances.getRowCount(), distances.getColumnCount()); // check expected dimensions

  // Splits data into rows per animal, producing a 101x101 array of distance values
  output = createWriter("formatted.csv"); // begin writing to file
  for (int i = 0; i < distances.getColumnCount ()-1; i++) {
    for (int k = 1; k <= 101; k++) {
      if (i == 101*k) {
        output.println(distances.getInt(0, i));
      }
    }
    output.print(distances.getInt(0, i)+",");
    output.flush();
  }
  output.close();
  Table formatted = loadTable("formatted.csv");
  formatted.removeColumn(101);
  println(formatted.getRowCount(), formatted.getColumnCount());

  ///////////// LOAD 'FORMATTED.csv' INTO R
  // 1. Open Trees.R file in R (recommend downloading RStudio for free)
  // 2. Run Trees.R script to display the resulting tree from formatted.csv distance matrix
  // 3. Adjust resulting tree image manually (see README)

  ///////////// CLUSTERING ALGORITHM (only sorts layers)
  // These programs work, just not implemented algorithms

  // This will print a sorted list of the distance between two animals from 0 (100% match) to 
  // 14 (0% match) for EVERY row (duplicated matches, due to matrix mirrioring)
  //      int newColumnRowCount = formatted.getColumnCount();
  //      println("distance,row,column,animal,animal");
  //    
  //      for (int count = 0; count < table.getColumnCount (); count++) { 
  //    
  //        for (int r = 0; r < newColumnRowCount; r++) {
  //          for (int c = 0; c < newColumnRowCount; c++) {
  //    
  //            if (formatted.getInt(r, c) == count) {
  //    
  //              println(formatted.getInt(r, c) +","+ r +","+ c +","+ 
  //                table.getString(r, 0) +","+
  //                table.getString(c, 0));
  //                
  //            }
  //          }
  //        }
  //      }

  // This will print a sorted list of the distance between two animals from 0 (100% match) to 
  // 14 (0% match) for the FIRST row
  //  int newColumnRowCount = formatted.getColumnCount();
  //  int level = 0;
  //  println("distance,row,column,animal,animal");
  //
  //  for (int count = 0; count < table.getColumnCount (); count++) { 
  //    int r = 0;
  //    for (int c = 0; c < newColumnRowCount; c++) {
  //      if (formatted.getInt(r, c) == count) {
  //        level++;   
  //        println(formatted.getInt(r, c) +","+ r +","+ c +","+ 
  //          table.getString(r, 0) +","+
  //          table.getString(c, 0));
  //      }
  //    }
  //  }

  f = createFont("Arial", 5, true); // set font
}

void draw() {
  background(255);
  image(img, 740, -95); // load tree image
  smooth();
  noStroke();

  Table formatted = loadTable("formatted.csv"); // load table for square filling
  Table table = loadTable("zoo.data.csv"); // load strings for labels

  // Contrast change interaction for the heatmap
  float threshold = 35;
  float a = (mouseY / (float) height) * -200;

  // Plots heatmap of animal relatedness
  int n = 0;
  for (int i = n; i <= formatted.getColumnCount ()-2; i++) {
    for (int j = n; j <= formatted.getRowCount ()-1; j++) {
      if (i == formatted.getColumnCount ()) {
        n = 0;
        fill(((formatted.getInt(j, i))*50)+a);
        rect(i*7, j*7, 6, 6);
      }
      fill(((formatted.getInt(j, i))*50)+a);
      rect(i*7, j*7, 6, 6);
    }
  }
  
  // Label canvas
  textFont(f, 16);
  text("Hierarchical Tree of Zoodata", 745, 740);
  text("Interactive Heatmap of Zoodata Distance Matrix", 30, 740);
  textFont(f, 12);
  text("Move the mouse cursor up and down to change contrast", 50, 758);
  text("black:      similar", 500, 758);
  text("white:      dis-similar", 500, 775);
  text("Hover over the animal names to enlarge", 50, 775);
  text("Single-linkage clustering", 765, 758);
  text("Ross Lagoy", width-75, height-10);
  
  textFont(f, 5);
  // Heatmap label interaction "hover"
  for (int i = 0; i < 101; i++) {
    fill(0);
    text(table.getString(i, 0), 715, 5+(i*7));
    if (mouseX < 750) {
      textFont(f, 8);
    } else {
      textFont(f, 5);
    }
  }
}

// References
// https://processing.org/tutorials/data/
// https://www.processing.org/reference/Table_getColumnCount_.html
