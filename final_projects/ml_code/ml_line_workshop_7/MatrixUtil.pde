/**
 * Bush School CPJava Class Final Project
 * Project Details: https://chandrunarayan.github.io/cpjava/final_projects/
 * static MatrixUtil class with static mprint() dnd mcrud() functions
 * used for creating matrices of random number weights and printing etc.
 */
static class MatrixUtil {

  /**
   * mprint function for debugging.
   * @param title: description of print outs following
   * @param in: input Matrix to print
   */
  static void mprint(boolean debug, String title, Matrix in) {
    if (debug) {
      System.out.println(String.format("%s:", title));
      // caling the Matrix print function
      in.print(3, 3);  // print 3 digits of precision for rows and cols
    }
  }

  /**
   * mcrud function for creating a random uniform distribution weights matrix.
   * @param rows: number of rows
   * @param cols: number of cols
   * @return out: return created matrix
   */
  static Matrix mcrud(int rows, int cols, double mean, double std) {
    // caling the Matrix random() to create a matrix of weights
    Random fRandom = new Random();
    Matrix m = new Matrix(rows, cols, 0.01);
    double[][] a = m.getArray();
    for (int r = 0; r<rows; r++) {
      for (int c = 0; c<cols; c++) {
        a[r][c] = mean + std * fRandom.nextGaussian();
      }
    }    
    return new Matrix(a);
  }
  /**
   * mmin function for finding min value in a matrix of values.
   * @param m: Matrix in which to find min
   * @return out: return max value
   */
  static double [] mmin(Matrix m) {
    double[][] a = m.getArray();
    double min = a[0][0];
    int rows = a.length;
    int cols = a[0].length;
    int index = 0;
    int minindex = 0;
    for (int r = 0; r<rows; r++) {
      for (int c = 0; c<cols; c++) {
        if (a[r][c]<min) {
          min = a[r][c];
          minindex = index;
        }
        index++;
      }
    }
    double [] retval = {min, minindex};
    return retval;
  }
  /**
   * mmax function for finding min value in a matrix of values.
   * @param m: Matrix in which to find max
   * @return out: return max value
   */
  static double [] mmax(Matrix m) {
    double[][] a = m.getArray();
    double max = a[0][0];
    int rows = a.length;
    int cols = a[0].length;
    int index = 0;
    int maxindex = 0;
    for (int r = 0; r<rows; r++) {
      for (int c = 0; c<cols; c++) {
        if (a[r][c]>max) {
          max = a[r][c];
          maxindex = index;
        }
        index++;
      }
    }
    double [] retval = {max, maxindex};
    return retval;
  }
  /**
   * m2colp function for printing 2 single-col matrices side-by-side
   * @param p: first column matrix
   * @param q: second column matrix
   */
  static void m2colp(Matrix p, Matrix q) {
    double[][] pA = p.getArray();
    double[][] qA = q.getArray();
    int pR = pA.length;
    int pC = pA[0].length;
    int qR = qA.length;
    int qC = qA[0].length;
    if (pR == qR && pC == 1 && qC == 1) { // 2 single col matrices of equal rows
      for (int i = 0; i<pR; i++) {
        System.out.println(String.format("%10.5f %10.5f", pA[i][0], qA[i][0]));
      }
    } else {
      System.out.println("input matrices are not 2 single col matrices of equal rows");
    }
  }
  /**
   * m3colp function for printing 3 single-col matrices side-by-side
   * @param p: first column matrix
   * @param q: second column matrix
   * @param r: third column matrix
   */
  static void m3colp(Matrix p, Matrix q, Matrix r) {
    double[][] pA = p.getArray();
    double[][] qA = q.getArray();
    double[][] rA = r.getArray();
    int pR = pA.length;
    int pC = pA[0].length;
    int qR = qA.length;
    int qC = qA[0].length;
    int rR = rA.length;
    int rC = rA[0].length;
    if (pR == qR && qR == rR && pC == 1 && qC == 1 && rC == 1) { // 3 single col matrices of equal rows
      for (int i = 0; i<pR; i++) {
        System.out.println(String.format("%10.5f %10.5f %10.5f", pA[i][0], qA[i][0], rA[i][0]));
      }
    } else {
      System.out.println("input matrices are not 3 single col matrices of equal rows");
    }
  }
}
