// Java program to demonstrate get
// and set pixel values of an image
double [][] getPixels(String fname) {
  BufferedImage img = null;
  File f = null;
  double [][] result = new double[0][0];

  // read image
  try {
    f = new File(
      fname);
    img = ImageIO.read(f);

    int width = img.getWidth();
    int height = img.getHeight();
    Raster raster=img.getData();
    result = new double [width][height];

    for (int row = 0; row < width; row++) {
      for (int col = 0; col < height; col++) {
        result[row][col] = raster.getSample(row, col, 0);
      }
    }
  }

  catch (IOException e) {
    System.out.println(e);
  }

  return result;
}

void write_test_csv(double[][] din, String fname_, String label) {
  try {
    // Creates a FileWriter
    FileWriter file = new FileWriter(fname_);

    // Creates a BufferedWriter
    BufferedWriter output = new BufferedWriter(file);

    output.write(label);
    for (int r = 0; r < din.length; r++) {
      for (int c = 0; c < din[0].length; c++) {
        String trail_comma = c == din[0].length-1 ? "" : ",";  // do not put last trailing comma
        String str = ""+din[r][c]+trail_comma;
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
