class Widget {
  float x, y, w, h;
  int date;
  
  Widget(float x, float y, float w, float h, int date) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.date = date;
  }
  
  void draw() {
    fill(200, 225, 255);
    rect(x, y, w, h, 100);
    fill(0);
    text(date, x + w / 2 - 5, y + h / 2);
  }
  
  int getDate() {
    return date;
  }
}
