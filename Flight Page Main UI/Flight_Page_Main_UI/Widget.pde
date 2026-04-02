class Widget {
  float x, y, w, h;
  String label = "";
  boolean selected = false;
  boolean roundedCorners = false;
  
  Widget(float x, float y, float w, float h, String label, boolean roundedCorners) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.roundedCorners = roundedCorners;
  }
  
  void draw() {
    if (selected) {
      fill(150);
    }
    else {
      fill(200);
    }
    if (label == "Search") {
      fill(200, 225, 255);
    }
    if (roundedCorners) {
      rect(x, y, w, h, 10);
    }
    else {
      rect(x, y, w, h); 
    }
    fill(0);
    textAlign(CENTER);
    text(label, x + w/2, y + h/2 + 5);
  }
}
