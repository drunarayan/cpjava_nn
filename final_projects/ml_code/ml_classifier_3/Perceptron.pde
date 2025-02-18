class Perceptron {
  float [] weights;

  Perceptron(int n) {
    weights = new float [n];
    for (int i = 0; i < weights.length; i++ ) {
      weights[i] = (float) (Math.random()) -0.5;
    }
  }

  float feedforward(float [] inputs) {
    float sum = 0, result;
    for (int i = 0; i < inputs.length; i++) {
      //System.out.printf("inputs[i]=%f\n", inputs[i]);
      sum += inputs[i]*weights[i];
    }
    //System.out.printf("sum=%f\n", sum);
    result = activate(sum);
    return result;
  }

  float activate(float sum) {
    return sum < 0.0 ? -1.0:1.0;
  }
}
