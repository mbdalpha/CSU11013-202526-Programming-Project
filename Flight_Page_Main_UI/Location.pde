class Location {

  float value;
  float x;
  String name;

  Location(float value, float x, String name) {
    this.value = value;
    this.x = x;
    this.name = name;
  }

  void draw(float bottomY, float chartHeight, float maxValue, float barWidth) {

    float barHeight = map(value, 0, maxValue, 0, chartHeight);
    float y = bottomY - barHeight;
    
    int valueInt = (int)value;
    
    fill(70, 130, 200);
    stroke(255);
    strokeWeight(1);
    rect(x + 10, y, barWidth - 10, barHeight);
    
    if (value > 0) {
      noStroke();
      fill(30); 
      textAlign(CENTER, BOTTOM);
      textSize(11);
      text(valueInt, x + 5 + barWidth / 2, y - 3);
    }

    fill(255);
    textAlign(CENTER, TOP);
    textSize(12);
    text(name, x + barWidth / 2, bottomY + 10);
  }
}
