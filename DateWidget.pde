class DateWidget {
  float x, y, r;
  int date;
  boolean selected = false;
  
  DateWidget(float x, float y, float r, int date) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.date = date;
  }
  
  void draw() {
    if (selected) {
      fill(150, 175, 215); //Selected widgets are dark blue
    }
    else {
      fill(200, 225, 255); //Unselected widgets are light blue
    }
    circle(x, y, r);
    fill(0);
    text(date, x, y);
  }
}
