import Jama.*;  

import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;
import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

/** ml_workshop_4 */
public class ml_workshop_4 {
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
 

// Globals
NeuralNetwork bushNN;
int input_nodes = 3;
int hidden_nodes = 3;
int output_nodes = 3;
float learning_rate = 0.1;

// Main
void setup() {
  // create my neural network
  bushNN = new NeuralNetwork(input_nodes, hidden_nodes, output_nodes, learning_rate);

// Create input data as a Column Matrix
// carefully note how the column matrix is initialized
// This will eventualy come from a file of input values
  double[][] ainp = {{0.9},
    {0.1},
    {0.8}};
    
  Matrix inp = new Matrix(ainp);  //column matrix of input values
  MatrixPrint.mprint("printing inputs to neural network", inp, input_nodes, input_nodes);  
  //inp.print(input_nodes, input_nodes);
  //inp.transpose().print(input_nodes, input_nodes);
  
  //Predict the output for a given set of inputs!
  // feedforward
  Matrix out = bushNN.predict(inp);
  
  MatrixPrint.mprint("printing final output from neural network", out, output_nodes, output_nodes);  
  //out.print(output_nodes, output_nodes);
  //out.transpose().print(input_nodes, input_nodes);

  bushNN.train(inp);
}

void draw() {
}
/**
 * Bush School CPJava Class Final Project
 * Project Details: https://chandrunarayan.github.io/cpjava/final_projects/
 * static Activator class with static sigmoid function 
 */
static class Activator {
  /**
   * sigmoid function for activation.
   * @param in: input Matrix of weighted sums  
   * @return out: calculated output matrix of sigmoid of weighted sums
   */  
  static Matrix sigmoid(Matrix in) {
    
    // first get the 2D array inside matrix
    double [][] inA = in.getArray();
    //  clone it
    double [][] outA = in.getArrayCopy();
    // put each weighted sum through the sigmoid function
    for (int i = 0; i < inA.length; i++) {
      for (int j = 0; j < inA[i].length; j++) {
        outA[i][j] = 1.0/(1+Math.exp(-inA[i][j]));
      }
    }
    
    Matrix out = new Matrix(outA);
    
    return out;
  }
}/**
 * Bush School CPJava Class Final Project
 * Project Details: https://chandrunarayan.github.io/cpjava/final_projects/
 * static MatrixPrint class with static mprint function 
 * used for debugging purposes
 */
static class MatrixPrint {
  /**
   * mprint function for debugging.
   * @param title: description of print outs following
   * @param in: input Matrix to print
   * @param rows: number of rows in matrix to print
   * @param rows: number of columns in matrix to print
   */   
  static void mprint(String title, Matrix in, int rows, int cols) {
    System.out.println(String.format("%s:", title));
    // caling the Matrix print function
    in.print(rows, cols);
  }
}/**
 * Bush School CPJava Class Final Project
 * Project Details: https://chandrunarayan.github.io/cpjava/final_projects/
 * NeuralNetwork class with predict() & train() functions 
 */
class NeuralNetwork {
  /** number of input nodes */
  int iNodes;
  /** number of hidden nodes */
  int hNodes;  
  /** number of output nodes */
  int oNodes;
  /** learning rate */
  float lRate;
  /** weights matrix in between input and hidden layers */
  Matrix wIH;  
  /** weights matrix in between hidden and output layers */
  Matrix wHO; 
  
  /**
   * Constructor for the Neural Network Class.
   * Initialize properties
   */  
  /** initialize nodes and lr */
  NeuralNetwork(int iNodes_, int hNodes_, int oNodes_, float lRate_) {
    iNodes = iNodes_;
    hNodes = hNodes_;
    oNodes = oNodes_;
    lRate = lRate_;

    // setup weights
    
    // initial input_hidden weights
    // this will eventually be created using a normal distribution of random numbers
    double[][] awIH = {{0.9, 0.3, 0.4},
      {0.2, 0.8, 0.2},
      {0.1, 0.5, 0.6}};
    wIH = new Matrix(awIH);  // weights matrix in between input and hidden layers
    MatrixPrint.mprint("printing initial input_hidden weights", wIH, hidden_nodes, hidden_nodes);

    // initial hidden_output weights
    // this will eventually be created using a normal distribution of random numbers
    double[][] awHO = {{0.3, 0.7, 0.5},
      {0.6, 0.5, 0.2},
      {0.8, 0.1, 0.9}};
    wHO = new Matrix(awHO);  // weights matrix in between hidden and output layers
    MatrixPrint.mprint("printing initial hidden_output weights", wHO, hidden_nodes, hidden_nodes);

  }
  
  /**
   * predict() function implementing feed forward calculations.
   * @param inp: Matrix of input values to Neural Network
   * @return out: Matrix of calculated output values from the Neural Network
   */  
  Matrix predict(Matrix inp) {
    
    // hidden layer calculations
    // hidden layer inputs: weighted sum
    Matrix hid_inp = wIH.times(inp);  // dot product to create the weighted sum
    //MatrixPrint.mprint("printing hidden layer inputs: weighted sum", hid_inp, hidden_nodes, hidden_nodes);

    // hidden layer outputs: sigmoid(weighted sum)
    // note: output of hidden layer is same as input of output layer
    Matrix hid_outp = Activator.sigmoid(hid_inp);  // simoid activation of the weighted sum
    //MatrixPrint.mprint("printing hidden layer outputs: sigmoid(weighted sum)", hid_outp, hidden_nodes, hidden_nodes);

    //output layer calculations
    //output of hidden layer is same as input of output layer
    Matrix out_outp = wHO.times(hid_outp);  // dot product to create the weighted sum
    //MatrixPrint.mprint("printing output layer inputs: weighted sum", out_outp, hidden_nodes, hidden_nodes);

    // calculate sigmoid activation of the weighted sum of the output layer
    Matrix out = Activator.sigmoid(out_outp); 
    return out;  // return the sigmoid activation of the weighted sum
  }

  /**
   * train() function for implementing backward propagation.
   * @param inp: Matrix of input values to train the Neural Network
   */ 
  void train(Matrix inp) {
    // Reverse Propagation
    // first feed forward!
    Matrix out = this.predict(inp);
    //MatrixPrint.mprint("printing first output from neural network before back propagation", out, output_nodes, output_nodes);
  }
}
}

