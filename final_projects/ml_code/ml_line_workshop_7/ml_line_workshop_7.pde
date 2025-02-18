/**
 * Bush School CPJava Class Final Project
 * Project Details: https://chandrunarayan.github.io/cpjava/final_projects/
 * 1. Build a complete Java Neural Network from scratch
 * 2. Test the Neural Network using 2 scenarios
 *    a. Predict equation of line using a supplied set of points
 *    b. Classify hand written 28x28 pixel numerals from 0-9
 * Adapted for Bush School by Chandru Narayan
 * from "Make your own Neural Network" by Tariq Rashid
 */

// Import NIST Java Matrix Library
// https://math.nist.gov/javanumerics/jama/Jama-1.0.3.jarhttps://math.nist.gov/javanumerics/jama/Jama-1.0.3.jar
// https://math.nist.gov/javanumerics/jama/doc/

import Jama.*;
import java.util.*;
import java.time.LocalDateTime;
import java.io.File;
import java.io.FileWriter;
import java.io.FileReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.awt.image.BufferedImage; 
import java.awt.image.Raster;
import java.io.IOException; 
import javax.imageio.ImageIO; 

// CONFIG SECTION

int TRAIN_AND_PREDICT = 0;
int PREDICT = 1;

int MODE = TRAIN_AND_PREDICT;

// Globals
NeuralNetwork bushNN; // the neural network
Matrix input, target, output[]; // input, target, and output Matrix globals


int input_nodes = 2;
int hidden_nodes = 7;
int output_nodes = 3;
int layers = 3;
float learning_rate = 0.1;
int nRec;  // number of records of input data for training neural network
int pIter = 100;   // print final output only after every pIter iterations
int epoch = 5;   // input batches
int error_count = 0;
int success_count = 0;
int num_train_pts = 10000;  // number of training points to create in input csv file per epoch
int num_test_pts = 10;  // number of training points to create in input csv file
String linreg_train_csv = "linreg_train.csv";
String linreg_test_csv = "linreg_test.csv";
String linreg_test_written_csv = "linreg_test_written.csv";
String wIH_csv = "wIH_weights.csv";
String wHO_csv = "wHO_weights.csv";
String data_folder_path;

double tgt_test_slope = (double) (Math.random());  // test target slope of line not known to ml
double tgt_test_offset = (double) (Math.random()); // test target offset of line not known to ml

boolean debug = false;

// Main
void setup() {
  noLoop();
  System.out.println("======== Program started ===========");
  System.out.println(LocalDateTime.now());

  data_folder_path = dataPath("");

  switch (MODE)
  {
  default:
  case 0:

    // create target line & input pts training csv file
    create_labeled_point_scatter_csv(num_train_pts, epoch, linreg_train_csv);
    // create target line & input pts test csv file after changing slope and offset
    create_point_scatter_csv(num_test_pts, linreg_test_csv);

    // create my neural network
    bushNN = new NeuralNetwork(input_nodes, hidden_nodes, output_nodes, learning_rate);

    // printing intial weight matrices matrices
    MatrixUtil.mprint(debug, "printing initial input_hidden weights", bushNN.wIH);
    MatrixUtil.mprint(debug, "printing initial hidden_output weights", bushNN.wHO);

    // Read the complete neural network training input as single lines array
    String[] lines = loadStrings(linreg_train_csv);
    nRec = lines.length;  // number of records of input data for training

    for (int rec = 0; rec < nRec; rec++) {
      String line = lines[rec];  // read the current record into line
      // create target & input for neural network
      // by processing every line (data point) in training input file

      // create input and target matrices for current record
      create_input_target_rec(line);
      // printing input and target matrices
      //MatrixUtil.mprint(debug, "\nprinting input matrix", input);
      //MatrixUtil.mprint(debug, "\nprinting target matrix", target);

      // train neural network (by calling predict() on current record
      bushNN.train(input, target);

      // printing progress only every pIter outputs
      if ((rec+1) % pIter == 0) {
        output = bushNN.predict(input);
        //calc statistics
        calc_stats(output[2]);

        String myStr = String.format("printing iteration %d output from neural network after adjusting weights", rec+1);
        MatrixUtil.mprint(debug, myStr, output[2]);
        print_progress(output[2], rec+1);
        print_results(output[2], rec+1);
        print_stats(rec+1);
      }
    }
    System.out.println("=======Training of neural network is complete!===========");
    System.out.println("=======Saving trained neural network weights!===========");
    bushNN.saveMatrix(bushNN.getwIH(), data_folder_path+"/"+wIH_csv);
    bushNN.saveMatrix(bushNN.getwHO(), data_folder_path+"/"+wHO_csv);

    // printing final adjusted weights
    MatrixUtil.mprint(true, "\nprinting final adjusted input_hidden weights", bushNN.wIH);
    MatrixUtil.mprint(true, "\nprinting final adjusted hidden_output weights", bushNN.wHO);

  case 1:
    if (MODE == PREDICT) {
      double[][] d_wih = read_csv_as_2d_array_of_doubles(data_folder_path+"/"+wIH_csv);
      double[][] d_who = read_csv_as_2d_array_of_doubles(data_folder_path+"/"+wHO_csv);
      Matrix m_wih = new Matrix(d_wih);
      Matrix m_who = new Matrix(d_who);
      // create my neural network and upload trained weights
      bushNN = new NeuralNetwork(input_nodes, hidden_nodes, output_nodes, learning_rate, m_wih, m_who);

      // printing final adjusted weights
      MatrixUtil.mprint(true, "\nprinting final adjusted input_hidden weights", bushNN.wIH);
      MatrixUtil.mprint(true, "\nprinting final adjusted hidden_output weights", bushNN.wHO);
    }

    System.out.println("=======Testing of neural network starts!===========");
    System.out.println("=======Printing test.csv===========");
    printDouble2D(read_csv_as_2d_array_of_doubles(data_folder_path+"/"+linreg_test_csv));
    
    // Read the complete neural network test input as single lines array
    lines = loadStrings(linreg_test_csv);
    nRec = lines.length;  // number of records of input data for training

    // predict result for each testing input
    // by processing every line (data point) in testing input file
    for (int rec = 0; rec < nRec; rec++) {
      String line = lines[rec];  // read the current record into line

      // create input and target matrices for current record
      create_input_rec(line);

      // predict results using calculated model
      output = bushNN.predict(input);
      //calc statistics
      calc_stats(output[2]);

      // printing progress only every pIter outputs
      pIter = 1;
      if ((rec+1) % pIter == 0) {
        String myStr = String.format("printing iteration %d output from neural network after adjusting weights", rec+1);
        MatrixUtil.mprint(debug, myStr, output[2]);
        print_progress(output[2], rec+1);
        print_results(output[2], rec+1);
        print_stats(rec+1);
      }
    }
  }
}

void draw() {
  System.out.println("======== FINAL PRINTS ===========");
  
  double[][] pixArray = getPixels(data_folder_path+"/"+"0.png");
  //printDouble2D(pixArray);
  write_test_csv(pixArray, data_folder_path+"/"+linreg_test_written_csv, "0");
  double [][] pwcsv = read_csv_as_2d_array_of_doubles(data_folder_path+"/"+linreg_test_written_csv);
  //MatrixUtil.mprint(true, "written test csv", new Matrix(pwcsv));  
  //printDouble2D(pwcsv);
  
  double [][] pcsv = read_csv_as_2d_array_of_doubles(data_folder_path+"/"+linreg_test_csv);
  //MatrixUtil.mprint(true, "test csv", new Matrix(pcsv));
  //printDouble2D(pcsv);
  System.out.println("======== Program ended ===========");
  System.out.println(LocalDateTime.now());
}
