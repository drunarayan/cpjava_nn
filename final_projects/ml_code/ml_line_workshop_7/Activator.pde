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
}
