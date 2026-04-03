class DateWidget {
  float x, y, r;
  int date;
  
  DateWidget(float x, float y, float r, int date) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.date = date;
  }
  
  void draw() {
    fill(200, 225, 255);
    circle(x, y, r);
    fill(0);
    text(date, x, y);
  }
}
