class Point {
  double x, y;
  
  Point() {
    x = (double) (Math.random());
    y = (double) (Math.random());
  }

  Point(double sl, double of) {
    x = (double) (Math.random());
    double line_ht_at_x = sl*x + of;
    y = Math.random() < 0.5 ? line_ht_at_x - 5*Math.random() : line_ht_at_x + 5*Math.random();
  }
}
