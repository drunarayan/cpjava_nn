int nwt = 3;
int npts = 100;
Perceptron pcp = new Perceptron(nwt);
Point [] pts = new Point [npts];
float [] out_pts = new float [npts];
float in_slope = (float) (Math.random()) -0.5;
float in_off = (float) (Math.random()) -0.5;

void setup() {
  size(500, 500);

  for (int i = 0; i < pts.length; i++) {
    pts[i] = new Point();
    float [] inp = { pts[i].x, pts[i].y, 1 };
    out_pts[i]=pcp.feedforward(inp);
  }

  //print_all();
}

float line_func(float x) {
  //y =  * x + in_off
  return in_slope * x + in_off;
}

float px(float x) {
  return map(x, -0.5, 0.5, 0, width);
}

float py(float y) {
  return map(y, -0.5, 0.5, height, 0);
}

void print_all() {

  System.out.println("weights:");
  for (int i = 0; i < pcp.weights.length; i++) {
    System.out.printf("%f ", pcp.weights[i]);
  }
  System.out.println();

  for (int i = 0; i < pts.length; i++) {
    System.out.println("points:");
    System.out.printf("%f %f \n", pts[i].x, pts[i].y);
    System.out.println("out_pts:");
    System.out.printf("%f\n", out_pts[i]);
  }
}

void draw() {
  background(255);
  for (int i = 0; i < pts.length; i++) {
    Point pt = pts[i];
    stroke(0);
    strokeWeight(1);
    noFill();
    ellipse(px(pt.x), py(pt.y), 16, 16);
    if (out_pts[i] > 0.0) {
      noStroke();
      fill(0, 255, 0);
      ellipse(px(pt.x), py(pt.y), 8, 8);
    } else {
      noStroke();
      fill(0, 0, 0);
      ellipse(px(pt.x), py(pt.y), 8, 8);
    }
  }
  stroke(255, 0, 0);
  strokeWeight(3);
  line(px(-1), py(line_func(-1)), px(1), py(line_func(1)));
}
