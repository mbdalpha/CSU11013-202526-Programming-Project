Widget[] widgets = new Widget[31];
String from = "from: ";
String to = "to: ";
boolean fromSelected = false;
boolean toSelected = false;

int cols = 7;
int cellW = 90;
int cellH = 70;
int startX = 20;
int startY = 80;

int dayOffset = 6;

void setup() {
  size (700, 500);
  textSize(20);
  
  for (int i = 0; i < 31; i++) {
    int date = i + 1;
    int gridIndex = dayOffset + i;
    int col = gridIndex % cols;
    int row = gridIndex / cols;
    
    int x = startX + col * cellW;
    int y = startY + row * cellH;
    
    widgets[i] = new Widget(x, y, cellW - 15, cellH - 15, date);
  }
}

void draw() {
  background(200);

  for (int i = 0; i < 31; i++) {
    widgets[i].draw();
  }
  text(from, 50, 30);
  text(to, 400, 30);
}

void mousePressed() {
  if (!fromSelected && !toSelected) {
    for (int i = 0; i < 31; i++) {
      if (mouseX > widgets[i].x &&
          mouseX < widgets[i].x + widgets[i].w &&
          mouseY > widgets[i].y &&
          mouseY < widgets[i].y + widgets[i].h) {
            from = from + widgets[i].getDate() + "/01/2022";
            fromSelected = true;
          }
       }
    }
  else if (!toSelected) {
    for (int i = 0; i < 31; i++) {
      if (mouseX > widgets[i].x &&
          mouseX < widgets[i].x + widgets[i].w &&
          mouseY > widgets[i].y &&
          mouseY < widgets[i].y + widgets[i].h) {
            to = to + widgets[i].getDate() + "/01/2022";
            toSelected = true;
          }
      }
  }
}
