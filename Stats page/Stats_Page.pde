int[] busyValues = {300, 800, 1200, 600, 1500, 300, 800, 1200, 600, 1500};
int[] Ranking = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
String[] busyAirportNames = {"LAX", "LHR", "JFK", "CDG", "DXB", "LAX", "LHR", "JFK", "CDG", "DXB"};
String[] leastReliableAirportNames = {"LAX", "LHR", "JFK", "CDG", "DXB", "LAX", "LHR", "JFK", "CDG", "DXB"};

int flightDataSize = 10000;
int step = flightDataSize / 10;

int spacing = 40;   
int startX = 120; 
int startY = 120;  
int currentPage = 1;
int totalPages = 3;

Airport[] theAirport = new Airport[10];
Marking marks;
Rank[] theRank = new Rank[10];

void setup() {

  background(255);
  size(700, 500);
  
  marks = new Marking(100, 450, 300, flightDataSize, step);
  
    for (int i = 0; i < 10; i++) {
      int xPos = startX + i * spacing;
      theAirport[i] = new Airport(busyValues[i], xPos, busyAirportNames[i]);
      int yPos = startY + i * spacing;
      theRank[i] = new Rank(Ranking[i], yPos, leastReliableAirportNames[i]);
      
    }
  }


void draw () {
  
  background(255);
  drawButtons();
  
  if (currentPage == 1) {
    drawPage1();
  } else if (currentPage == 2) {
    drawPage2();
  } else if (currentPage == 3) {
    drawPage3();
  }
    
}

void drawButtons() {
  
  if(currentPage!=1) {
    fill(200);
    rect(20, 20, 100, 40);
    fill(0);
    textSize(16);
    text("Prev", 45, 45);
  }

  if(currentPage!=3) {
    fill(200);
    rect(width - 120, 20, 100, 40);
    fill(0);
    text("Next", width - 95, 45);
  }
  
  fill(200);
  rect(10, 460, 75, 30);
  fill(0);
  textSize(16);
  text("Exit", 30, 480);
}

void mousePressed() {
  if (mouseX > 20 && mouseX < 120 &&
      mouseY > 20 && mouseY < 60) {
    
    currentPage--;
    if (currentPage < 1) {
      currentPage = totalPages; 
    }
  }

  if (mouseX > width - 120 && mouseX < width - 20 &&
      mouseY > 20 && mouseY < 60) {
    
    currentPage++;
    if (currentPage > totalPages) {
      currentPage = 1;
    }
  }
  
  if (mouseX > 10 && mouseX < 85 &&
      mouseY > 460 && mouseY < 490) {
    
    currentPage--;
    if (currentPage < 1) {
      currentPage = totalPages; 
    }
  }
}

void drawPage1() {
  fill(100);
  rect(100, 100, 1, 350); 
  rect(100, 450, 500, 1);
  
  textSize(15);
  text("Airport", 600, 475); 
  textSize(15);
  text("No of flights", 10, 100); 
  
  textSize(35);
  text("Busiest Airport Bar Chart", 170, 55); 
  
  marks.draw();
    
  for (int i = 0; i < 10 ; i++) {
    theAirport[i].draw();
  }
}

void drawPage2() {
  
  fill(100);
  textSize(35);
  text("Least reliable Airport Ranking", 140, 55); 

  for (int i = 0; i < 10; i++) {
    theRank[i].draw();
  }
}

void drawPage3() {
  fill(100);
  textSize(35);
  text("Least reliable Airport Ranking", 140, 55); 
}
