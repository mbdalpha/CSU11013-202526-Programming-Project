/*
CHANGELOG:
N. Puligundla commits Marking.pde, 02/04/2026
N. Puligundla adds comments, 6/04/2026
*/

// Draws Y-axis markings and grid lines
class Marking {
  float x;          // X-position of the Y-axis
  float yBottom;    // Y-coordinate of the bottom of the chart
  float chartHeight;
  int maxValue;     // Maximum value on the Y-axis
  int step;         // Step interval between markings          

  Marking(float x, float yBottom, float chartHeight, int maxValue, int step) {
    this.x = x;
    this.yBottom = yBottom;
    this.chartHeight = chartHeight;
    this.maxValue = maxValue;
    this.step = step;
  }

  // Draws horizontal grid lines, tick marks, and labels
  void draw() {
    stroke(0);
    fill(255);
    textSize(10);

    // Loop over values from 0 to maxValue in increments of step
    for (int value = 0; value <= maxValue; value += step) {
      
      if (value >= 1) {    
        float y = map(value, 0, maxValue, yBottom, yBottom - chartHeight); 
          
          // Draw grid line
          stroke(220);
          strokeWeight(1);
          line(x, y, 1100, y); 

	      // Draw tick mark
          stroke(150);
          line(x - 5, y, x, y);

          // Draw numeric label
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
