class Marking {
  float x;          
  float yBottom;   
  float chartHeight;
  int maxValue;     
  int step;         

  Marking(float x, float yBottom, float chartHeight, int maxValue, int step) {
    this.x = x;
    this.yBottom = yBottom;
    this.chartHeight = chartHeight;
    this.maxValue = maxValue;
    this.step = step;
  }

  void draw() {
    stroke(0);
    fill(0);
    textSize(10);

    for (int value = 0; value <= maxValue; value += step) {
      
      if (value >= 1) {    
        float y = map(value, 0, maxValue, yBottom, yBottom - chartHeight);
        line(x - 5, y, x, y);
        text(value, x - 40, y + 4);
      }
      
      else;
      
    }
  }
}
