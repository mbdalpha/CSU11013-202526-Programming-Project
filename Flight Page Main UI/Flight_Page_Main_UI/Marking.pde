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
    fill(255);
    textSize(10);

    for (int value = 0; value <= maxValue; value += step) {
      
      if (value >= 1) {    
        float y = map(value, 0, maxValue, yBottom, yBottom - chartHeight);        
          stroke(220);
          strokeWeight(1);
          line(x, y, 1100, y); 
    
          stroke(150);
          line(x - 5, y, x, y);
          
          noStroke();
          fill(255);
          textAlign(RIGHT, CENTER);
          textSize(12);
          text(value, x - 10, y);    
      }
      
      else;
      
    }
  }
}
