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
import java.nio.file.*;
import java.awt.image.BufferedImage;
import java.awt.image.Raster;
import java.io.IOException;
import java.util.stream.*;
import javax.imageio.ImageIO;

// Globals
NeuralNetwork bushNN; // the neural network
Matrix input, target, output[]; // input, target, and output Matrix globals
int input_nodes = 784;
int hidden_nodes = 100;
int output_nodes = 10;
int layers = 3;
float learning_rate = 0.3;
int nRec;  // number of records of input data for training neural network
int pIter = 10000;   // print final output only after every pIter iterations
int error_count = 0;
int success_count = 0;
String [] lines;
String data_folder_path;
String user_test_written_csv = "user_test_written.csv";

double tgt_test_slope = (double) (Math.random());  // test target slope of line not known to ml
double tgt_test_offset = (double) (Math.random()); // test target offset of line not known to ml

boolean debug = false;

// Main
void setup() {
  noLoop();
  System.out.println("======== Program started ===========");
  System.out.println(LocalDateTime.now());

  data_folder_path = dataPath("");

  // create my neural network
  bushNN = new NeuralNetwork(input_nodes, hidden_nodes, output_nodes, learning_rate);

  MatrixUtil.mprint(debug, "printing initial input_hidden weights", bushNN.wIH);
  MatrixUtil.mprint(debug, "printing initial hidden_output weights", bushNN.wHO);

  // Read the complete neural network training input as single lines array
  lines = loadStrings("mnist_train.csv");
  nRec = lines.length;  // number of records of input data for training

  // create input & target for neural network
  // by processing every line (data point) in training input file
  for (int rec = 0; rec < nRec; rec++) {
    String line = lines[rec];  // read the current record into line

    // create input and target matrices for current record
    create_input_target(line);

    // train neural network (by calling predict() on current record
    bushNN.train(input, target);

    // printing progress only every pIter outputs
    if ((rec+1) % pIter == 0) {
      output = bushNN.predict(input);
      String myStr = String.format("printing iteration %d output from neural network after adjusting weights", rec+1);
      MatrixUtil.mprint(debug, myStr, output[2]);
      print_progress(output[2], rec+1);
      print_results(output[2], rec+1);
    }
  }
  System.out.println("=======Training of neural network is complete!===========");

  // printing final adjusted weights
  MatrixUtil.mprint(false, "\nprinting final adjusted input_hidden weights", bushNN.wIH);
  MatrixUtil.mprint(false, "\nprinting final adjusted hidden_output weights", bushNN.wHO);

  System.out.println("=======MNIST Testing of neural network starts!===========");
  // Read the complete neural network test input as single lines array
  lines = loadStrings("mnist_test.csv");
  nRec = lines.length;  // number of records of input data for training

  // predict result for each testing input
  // by processing every line (data point) in testing input file
  for (int rec = 0; rec < nRec; rec++) {
    String line = lines[rec];  // read the current record into line

    // create input and target matrices for current record
    create_input_target(line);

    // predict results using calculated model
    output = bushNN.predict(input);

    //calc statistics
    calc_stats(output[2]);

    // printing progress only every pIter outputs
    pIter = 1000;
    if ((rec+1) % pIter == 0) {
      String myStr = String.format("printing iteration %d output from neural network after adjusting weights", rec+1);
      MatrixUtil.mprint(debug, myStr, output[2]);
      print_progress(output[2], rec+1);
      print_results(output[2], rec+1);
      print_stats(rec+1);
    }
  }
}

void draw() {

  System.out.println("======== FINAL PRINTS ===========");
  error_count = 0;
  success_count = 0;

  //double[][] pixArray = getPixels(data_folder_path+"/"+"7.png");
  //printDouble2D(pixArray);
  //write_test_csv(pixArray, data_folder_path+"/"+user_test_written_csv, "7");
  //double [][] pwcsv = read_csv_as_2d_array_of_doubles(data_folder_path+"/"+user_test_written_csv);
  //MatrixUtil.mprint(true, "written test csv", new Matrix(pwcsv));
  //printDouble2D(pwcsv);
  create_test_csv_from_images_folder(data_folder_path+"/images", data_folder_path+"/"+user_test_written_csv);

  //double [][] pcsv = read_csv_as_2d_array_of_doubles(data_folder_path+"/"+"mnist_test.csv");
  //MatrixUtil.mprint(true, "test csv", new Matrix(pcsv));
  //printDouble2D(pcsv);
  System.out.println("=======USER TESTING of neural network starts!===========");
  // Read the complete neural network test input as single lines array
  lines = loadStrings("user_test_written.csv");
  nRec = lines.length;  // number of records of input data for training

  // predict result for each testing input
  // by processing every line (data point) in testing input file
  for (int rec = 0; rec < nRec; rec++) {
    String line = lines[rec];  // read the current record into line

    // create input and target matrices for current record
    create_input_target(line);

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

  System.out.println("======== Program ended ===========");
  System.out.println(LocalDateTime.now());
  System.out.println("======== Program ended ===========");
  System.out.println(LocalDateTime.now());
}
