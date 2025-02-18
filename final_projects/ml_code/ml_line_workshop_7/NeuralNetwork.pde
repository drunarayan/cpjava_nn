/**
 * Bush School CPJava Class Final Project
 * Project Details: https://chandrunarayan.github.io/cpjava/final_projects/
 * NeuralNetwork class with predict() and train() functions
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

    boolean debug = false;

    // setup weights

    // initial input_hidden weights
    // created using a normal distribution of random numbers
    wIH = MatrixUtil.mcrud(hNodes, iNodes, 0.0, Math.pow(iNodes, -0.5));  // weights matrix in between input and hidden layers
    MatrixUtil.mprint(debug, "printing initial input_hidden weights wIH", wIH);
    //System.out.println(System.out.format("printing min value of wIH %f", MatrixUtil.mmin(wIH)));
    //System.out.println(System.out.format("printing max value of wIH %f", MatrixUtil.mmax(wIH)));


    // initial hidden_output weights
    // created using a normal distribution of random numbers
    wHO = MatrixUtil.mcrud(oNodes, hNodes, 0.0, Math.pow(hNodes, -0.5));  // weights matrix in between hidden and output layers
    MatrixUtil.mprint(debug, "printing initial hidden_output weights wHO", wHO);
    //System.out.println(System.out.format("printing min value of wHO %f", MatrixUtil.mmin(wHO)));
    //System.out.println(System.out.format("printing max value of wHO %f", MatrixUtil.mmax(wHO)));
  }
  // overloaded constructor for trained network
  NeuralNetwork(int iNodes_, int hNodes_, int oNodes_, float lRate_, Matrix wIH_, Matrix wHO_) {
    iNodes = iNodes_;
    hNodes = hNodes_;
    oNodes = oNodes_;
    lRate = lRate_;

    boolean debug = false;

    // setup weights

    // trained wIH input_hidden weights are passed in - no training needed
    setwIH(wIH_);  // weights matrix in between input and hidden layers
    MatrixUtil.mprint(debug, "printing trained input_hidden weights wIH", wIH);

    // trained wHO hidden_output weights are passed in - no training needed
    setwHO(wHO_);  // weights matrix in between hidden and output layers
    MatrixUtil.mprint(debug, "printing trained hidden_output weights wHO", wHO);
    //System.out.println(System.out.format("printing min value of wHO %f", MatrixUtil.mmin(wHO)));
    //System.out.println(System.out.format("printing max value of wHO %f", MatrixUtil.mmax(wHO)));
  }  
  
  /**
   * getwIH() function to get wIH Matrix.
   * @return res: Matrix of current input_hidden weights of Neural Network
   */  
  Matrix getwIH() {
    return wIH;
  }
  
  /**
   * getwHO() function to get wHO Matrix.
   * @return res: Matrix of current hidden_output weights of Neural Network
   */  
  Matrix getwHO() {
    return wHO;
  }
  
  /**
   * setwHO() function to set wHO Matrix.
   * @param wHO_: Matrix containing new hidden_output weights of Neural Network
   */
  void setwHO(Matrix wHO_) {
    wHO = wHO_;
  }   
  
  /**
   * setwIH() function to set wIH Matrix.
   * @param wIH_: Matrix containing new input_hidden weights of Neural Network
   */
  void setwIH(Matrix wIH_) {
    wIH = wIH_;
  }
  
  /**
   * setwIH() function to set wIH Matrix.
   * @param wIH_: Matrix containing new input_hidden weights of Neural Network
   */
  void saveMatrix(Matrix mat_, String fname_) {
    write_2d_array_of_doubles_as_csv(mat_.getArray(), fname_);
  }  
  
  /**
   * predict() function implementing feed forward calculations.
   * @param inp: Matrix of input values to Neural Network
   * @return res: Matrix [] an array of matrices with calculated output values from the Neural Network
   */
  Matrix [] predict(Matrix inp_) {
    boolean debug = false;
    // create Matrix array to store hidden_input, hidden_output, and final_output values
    Matrix [] res = new Matrix [layers];

    // hidden layer calculations
    // hidden layer inputs: weighted sum

    Matrix hid_inp = wIH.times(inp_);  // dot product to create the weighted sum
    MatrixUtil.mprint(debug, "printing hidden layer inputs: weighted sum", hid_inp);
    res[0] = hid_inp;  // store hidden weighted sum in in res in Matrix array

    // hidden layer outputs: sigmoid(weighted sum)
    // note: output of hidden layer is same as input of output layer
    Matrix hid_outp = Activator.sigmoid(hid_inp);  // sigmoid activation of the weighted sum
    MatrixUtil.mprint(debug, "printing hidden layer outputs: sigmoid(weighted sum)", hid_outp);
    res[1] = hid_outp; // store hidden sigmoid output in res Matrix array

    //output layer inputs: weighted sum
    //input to output layer is same as output from hidden layer
    Matrix out_inp = wHO.times(hid_outp);  // dot product to create the weighted sum
    MatrixUtil.mprint(debug, "printing output layer inputs: weighted sum", out_inp);

    // calculate sigmoid activation of the weighted sum of the output layer
    Matrix out_outp = Activator.sigmoid(out_inp);
    MatrixUtil.mprint(debug, "printing output layer outputs : sigmoid(weighted sum)", out_outp);
    res[2] = out_outp;  // store hidden sigmoid output in res Matrix array

    return res;  // return the sigmoid activation of the weighted sum
  }

  /**
   * train() function for implementing backward propagation.
   * @param inp: Matrix of input values to train the Neural Network
   */
  void train(Matrix inp_, Matrix tgt_) {
    // Back Propagation
    // first feed forward!

    boolean debug = false;

    //System.out.println("***** Feed Forward Starts *******");

    MatrixUtil.mprint(debug, "printing inputs to neural network", inp_);
    MatrixUtil.mprint(debug, "printing targets to neural network", tgt_);

    Matrix [] res = this.predict(inp_);

    MatrixUtil.mprint(debug, "printing hidden layer inputs: weighted sum", res[0]);
    MatrixUtil.mprint(debug, "printing hidden layer outputs: sigmoid(weighted sum)", res[1]);
    MatrixUtil.mprint(debug, "printing output layer inputs = hidden_layer outputs", res[1]);
    MatrixUtil.mprint(debug, "printing output layer outputs = final outputs", res[2]);

    Matrix output_error = tgt_.minus(res[2]);
    MatrixUtil.mprint(debug, "printing output_error from neural network", output_error);

    Matrix hidden_error = wHO.transpose().times(output_error);
    MatrixUtil.mprint(debug, "printing hidden errors from neural network", hidden_error);

    //System.out.println("***** Back Propagations Starts *******");

    Matrix unity_output = new Matrix(output_nodes, 1, 1.0);  // Create a column matrix of 1.0 to use in 1-sigmoid calculation

    // Update weights between hidden and output layers based on output error
    Matrix lhdot1 = output_error.arrayTimes(res[2].arrayTimes(unity_output.minus(res[2])));
    Matrix lhdot2 = res[1].transpose();
    wHO.plusEquals(lhdot1.times(lhdot2).times(lRate));
    MatrixUtil.mprint(debug, "printing updated weights between hidden and output layers", wHO);

    Matrix unity_hidden = new Matrix(hidden_nodes, 1, 1.0);  // Create a column matrix of 1.0 to use in 1-sigmoid calculation

    // Update weights between input and hidden layers based on calculated error
    Matrix lhdot3 = hidden_error.arrayTimes(res[1].arrayTimes(unity_hidden.minus(res[1])));
    Matrix lhdot4 = inp_.transpose();
    wIH.plusEquals(lhdot3.times(lhdot4).times(lRate));
    MatrixUtil.mprint(debug, "printing updated weights between input and hidden layers", wIH);
  }
}
