/**
 * Bush School CPJava Class Final Project
 * Project Details: https://chandrunarayan.github.io/cpjava/final_projects/
 * ML utiltiy functions used in main
 * used for 2D arrays, file I/O, etc
 */
import java.io.File;
import java.io.FileWriter;
import java.io.FileReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;

public static double[][] read_csv_as_2d_array_of_doubles(String file) {
  double [][] d = new double [0][0];
  try {
    Scanner input = new Scanner(new FileReader(file));
    List<List<Double>> al = new ArrayList<>();
    while (input.hasNextLine()) {
      String line = input.nextLine();
      List<Double> ll = new ArrayList<>();
      Scanner sc = new Scanner(line);
      sc.useDelimiter(",");
      while (sc.hasNextDouble()) {
        ll.add(sc.nextDouble());
      }
      al.add(ll);
    }
    d = new double[al.size()][];
    for (int i = 0; i < al.size(); i++) {
      List<Double> list = al.get(i);
      d[i] = new double[list.size()];
      for (int j = 0; j < d[i].length; j++) {
        d[i][j] = list.get(j);
      }
    }
  }
  catch (Exception e) {
    System.out.println("file EXCEPTION !!");
    e.getStackTrace();
  }
  return d;
}

void write_2d_array_of_doubles_as_csv(double[][] din, String fname_) {
  try {
    // Creates a FileWriter
    FileWriter file = new FileWriter(fname_);

    // Creates a BufferedWriter
    BufferedWriter output = new BufferedWriter(file);

    for (int r = 0; r < din.length; r++) {
      for (int c = 0; c < din[0].length; c++) {
        String trail_comma = c == din[0].length-1 ? "" : ",";  // do not put last trailing comma
        String str = ""+din[r][c]+trail_comma;
        output.write(str);
      }
      output.write("\n");;
    }

    // Closes the writer
    output.close();
  }

  catch (Exception e) {
    System.out.println("file EXCEPTION !!");
    e.getStackTrace();
  }
}

void write_2d_array_of_ints_as_csv(double[][] din, String fname_) {
  try {
    // Creates a FileWriter
    FileWriter file = new FileWriter(fname_);

    // Creates a BufferedWriter
    BufferedWriter output = new BufferedWriter(file);

    for (int r = 0; r < din.length; r++) {
      for (int c = 0; c < din[0].length; c++) {
        String trail_comma = c == din[0].length-1 ? "" : ",";  // do not put last trailing comma
        String str = ""+din[r][c]+trail_comma;
        output.write(str);
      }
      output.write("\n");;
    }

    // Closes the writer
    output.close();
  }

  catch (Exception e) {
    System.out.println("file EXCEPTION !!");
    e.getStackTrace();
  }
}

void printInt2D(int [][] dd) {
  for (int r = 0; r < dd.length; r++) {
    for (int c = 0; c < dd[0].length; c++) {
      String trail_comma = c == dd[0].length-1 ? "" : ",";  // do not put last trailing comma
      System.out.print(""+dd[r][c]+trail_comma);
    }
    System.out.println();
  }
}

void printDouble2D(double [][] dd) {
  for (int r = 0; r < dd.length; r++) {
    for (int c = 0; c < dd[0].length; c++) {
      String trail_comma = c == dd[0].length-1 ? "" : ",";  // do not put last trailing comma
      System.out.print(""+dd[r][c]+trail_comma);
    }
    System.out.println();
  }
}

void print_progress(Matrix out, int iter) {
  Matrix output_error = target.minus(out);
  String myStr = String.format("\nprinting final_output, target and output_error from neural network after %d iterations", iter);
  System.out.println(myStr);
  MatrixUtil.m3colp(out, target, output_error);
}

void print_results(Matrix out, int rec) {
  double [] res1 = MatrixUtil.mmax(out);
  double nn_prediction = res1[1];
  double [] res2 = MatrixUtil.mmax(target);
  double nn_target = res2[1];
  System.out.println(System.out.format("For input record %d hand-writtten numeral %.1f neural network predicts %.1f\n", rec, nn_target, nn_prediction));
}

void print_stats(int rec) {
  System.out.println("success count: " + success_count);
  System.out.println("error count: " + error_count);
  System.out.println("total count: " + (success_count+error_count));
  System.out.println(System.out.format("For all %d hand-writtten numerals neural network prediction accuracy is %.1f percent \n", rec, ((double)success_count/(error_count+success_count)*100.0)));
}

void calc_stats(Matrix out) {
  double [] res1 = MatrixUtil.mmax(out);
  double nn_prediction = res1[1];
  double [] res2 = MatrixUtil.mmax(target);
  double nn_target = res2[1];
  if (Math.abs(nn_target - nn_prediction) < 0.01) {
    success_count++;
  } else {
    error_count++;
  }
}

void create_input_target(String curr) {
  // create target for neural network from current record
  // first element of every line is the target
  double[][] atgt = new double[output_nodes][1];  // building a single-column array of output_nodes rows

  // initalize all values to zero (0.01)
  for (int r = 0; r < atgt.length; r++) {
    for (int c = 0; c < atgt[0].length; c++) {
      atgt[r][c] = 0.01;
    }
  }
  atgt[(int)(Double.parseDouble(curr.substring(0, 1)))][0] = 0.99; // set the value of the "target" element to 1 (0.99)
  target = new Matrix(atgt);  // convert 2D array to a Matrix

  // create input for neural network from current record
  // by processing every line (data point) in training input

  // Create an ArrayList of doubles from each record of CSV
  ArrayList<Double> linp = new ArrayList<Double> ();
  List<String> items = Arrays.asList(curr.split(","));
  for (int i = 0; i < items.size(); i++) {
    linp.add(Double.parseDouble(items.get(i)));
  }

  // Build a single column array of input values from list
  double[][] ainp = new double[input_nodes][1]; // building a single-column array of input_nodes rows
  for (int i = 1; i < ainp.length; i++) {  // note that we are skipping past the first element as it is the target!
    double pix = linp.get(i);
    ainp[i-1][0] = pix/255.0 * 0.99 + 0.01;  // normalize between 0.01 and 0.99
  }

  // create input for neural network from current record
  // first element of every line is the target
  input = new Matrix(ainp);  // convert 2D array to a Matrix
}

void create_input_rec(String curr) {
  double[][] ainp = new double[input_nodes][1]; // building a single-column array of input_nodes rows
  // initalize all values to zero (0.01)
  for (int r = 0; r < ainp.length; r++) {
    for (int c = 0; c < ainp[0].length; c++) {
      ainp[r][c] = 0.01;
    }
  }

  // create input for neural network from current record
  // by processing every line (data point) in test input

  // Create an ArrayList of doubles from each record of CSV
  ArrayList<Double> linp = new ArrayList<Double> ();
  List<String> items = Arrays.asList(curr.split(","));
  for (int i = 0; i < items.size(); i++) {
    linp.add(Double.parseDouble(items.get(i)));
  }

  // Build a single column array of input values from list
  // index 0 is xval and index 1 is yval
  for (int i = 0; i < ainp.length; i++) {
    ainp[i][0] = linp.get(i); // 3rd of 4th element of the record
  }
  input = new Matrix(ainp);  // convert 2D array to a Matrix
  adjust_target(tgt_test_slope, tgt_test_offset);
}

void adjust_target(double test_slope, double test_offset) {
  double[][] atgt = new double[output_nodes][1];  // building a single-column array of target rows
  // initalize all values to zero (0.01)
  for (int r = 0; r < atgt.length; r++) {
    for (int c = 0; c < atgt[0].length; c++) {
      atgt[r][c] = 0.01;
    }
  }
  // Build a single column array of target values from list
  // index 0 is slope, index 1 is offset, index 2 is elev (above or below)
  atgt[0][0] = test_slope;
  atgt[1][0] = test_offset;

  target = new Matrix(atgt);  // convert 2D array to a Matrix
}

void create_labeled_point_scatter_csv(int npts, int nepoch, String fname) {
  try {
    // Creates a FileWriter
    FileWriter file = new FileWriter(data_folder_path+"/"+fname);

    // Creates a BufferedWriter
    BufferedWriter output = new BufferedWriter(file);

    for (int e = 0; e < nepoch; e++) {
      Point [] pts = new Point [npts];
      double tgt_train_slope = (double) (Math.random());  // train target slope of line
      double tgt_train_offset = (double) (Math.random()); // train target offset of line
      for (int i = 0; i < pts.length; i++) {
        // Create a point
        pts[i] = new Point();
        double elev = (tgt_train_slope * pts[i].x + tgt_train_offset) > pts[i].x ? -1 : 1;
        // Writes the string to the file
        String str = ""+tgt_train_slope+","+tgt_train_offset+","+elev+","+pts[i].x+","+pts[i].y+"\n";
        //System.out.print(str);
        output.write(str);
      }
    }

    // Closes the writer
    output.close();
  }

  catch (Exception e) {
    System.out.println("file EXCEPTION !!");
    e.getStackTrace();
  }
}

void create_point_scatter_csv(int npts, String fname) {
  try {
    // Creates a FileWriter
    FileWriter file = new FileWriter(data_folder_path+"/"+fname);

    // Creates a BufferedWriter
    BufferedWriter output = new BufferedWriter(file);

    //Using the target test slope and offset cretate the input points half above and half below
    Point [] pts = new Point [npts];
    for (int i = 0; i < pts.length; i++) {
      // Create a point
      pts[i] = new Point(tgt_test_slope, tgt_test_offset);
      // Writes the string to the file
      String str = ""+pts[i].x+","+pts[i].y+"\n";
      //System.out.print(str);
      output.write(str);
    }

    // Closes the writer
    output.close();
  }

  catch (Exception e) {
    System.out.println("file EXCEPTION !!");
    e.getStackTrace();
  }
}
