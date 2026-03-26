int[] busyValues = {300, 800, 1200, 600, 1500, 300, 800, 1200, 600, 1500};
int[] Ranking = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
int[] flightCounts;
String[] busyAirportNames = {"LAX", "LHR", "JFK", "CDG", "DXB", "LAX", "LHR", "JFK", "CDG", "DXB"};
String[] leastReliableAirportNames = {"LAX", "LHR", "JFK", "CDG", "DXB", "LAX", "LHR", "JFK", "CDG", "DXB"};

int flightDataSize = 2000;
int step = flightDataSize / 10;

int spacing = 40;   
int startX = 120; 
int startY = 120;  
int currentPage = 1;
int totalPages = 3;

String[] xLabels;
int totalBars = 15;
int totalLateFlights = 0;

Airport[] theAirport = new Airport[10];
Marking marks;
Rank[] theRank = new Rank[10];

void setup() {

  background(255);
  size(700, 500);
  
  textFont(createFont("Arial", 12));
  marks = new Marking(100, 450, 300, flightDataSize, step);
  
    for (int i = 0; i < 10; i++) {
      int xPos = startX + i * spacing;
      theAirport[i] = new Airport(busyValues[i], xPos, busyAirportNames[i]);
      int yPos = startY + i * spacing;
      theRank[i] = new Rank(Ranking[i], yPos, leastReliableAirportNames[i]);
      
    }
    
    for (int i = 0; i < totalBars - 1; i++) {
      int rangeStart = 15 + i * 20;
      int rangeEnd = rangeStart + 20;
      xLabels[i] = rangeStart + "-" + rangeEnd;
    }
    
    xLabels[totalBars - 1] = "300+";

    loadCSVData("flights2k(1) (1) (2).csv");
    noLoop();

  }
  
void loadCSVData(String filename) {
  Table table = loadTable(filename, "header");

  for (TableRow row : table.rows()) {
    if (row.getString("CANCELLED").trim().startsWith("1")) continue;
    if (row.getString("DIVERTED").trim().startsWith("1")) continue;

    String actualArrival    = row.getString("ARR_TIME").trim();
    String scheduledArrival = row.getString("CRS_ARR_TIME").trim();
    if (actualArrival.length() == 0 || scheduledArrival.length() == 0) continue;

    int scheduledHHMM = int(float(scheduledArrival));
    int actualHHMM    = int(float(actualArrival));
    int scheduledMins = (scheduledHHMM / 100) * 60 + (scheduledHHMM % 100);
    int actualMins    = (actualHHMM    / 100) * 60 + (actualHHMM    % 100);

    float minutesLate = actualMins - scheduledMins;

    if (minutesLate < -720) minutesLate += 1440;
    if (minutesLate >  720) minutesLate -= 1440;

    if (minutesLate < 15) continue;

    totalLateFlights++;

    if (minutesLate >= 300) {
      flightCounts[totalBars - 1]++;
    } else {
      int barIndex = int((minutesLate - 15) / 20);
      if (barIndex >= 0 && barIndex < totalBars - 1) flightCounts[barIndex]++;
    }
  }
}




void draw () {
  
  background(255);
  
  noStroke();
  fill(18, 136, 179);
  rect(0, 0, 700, 83);
  
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
    if (currentPage <= 1) {
      currentPage = 1; 
    }
  }

  if (mouseX > width - 120 && mouseX < width - 20 &&
      mouseY > 20 && mouseY < 60) {
    
    currentPage++;
    if (currentPage >= totalPages) {
      currentPage = totalPages;
    }
  }
  
  if (mouseX > 10 && mouseX < 85 &&
      mouseY > 460 && mouseY < 490) {
    
      exit();
  }
}

void drawPage1() {
  fill(100);
  rect(100, 100, 1, 350); 
  rect(100, 450, 500, 1);
  
  fill(0);
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
  
  fill(0);
  textSize(35);
  text("Least reliable Airport Ranking", 135, 55); 

  for (int i = 0; i < 10; i++) {
    theRank[i].draw();
  }
}

void drawPage3() {
  background(255);

  int leftPad = 80, rightPad = 30, topPad = 60, bottomPad = 90;
  int chartWidth  = width  - leftPad - rightPad;
  int chartHeight = height - topPad  - bottomPad;

  int tallestBar = 0;
  for (int count : flightCounts) if (count > tallestBar) tallestBar = count;

  float barWidth = (float)chartWidth / totalBars;

  int numberOfYLines = 6;
  for (int i = 0; i <= numberOfYLines; i++) {
    float yValue   = map(i, 0, numberOfYLines, 0, tallestBar);
    float yOnScreen = map(i, 0, numberOfYLines, topPad + chartHeight, topPad);

    stroke(220);
    strokeWeight(1);
    line(leftPad, yOnScreen, leftPad + chartWidth, yOnScreen);

    stroke(150);
    line(leftPad - 5, yOnScreen, leftPad, yOnScreen);

    noStroke();
    fill(50);
    textAlign(RIGHT, CENTER);
    textSize(12);
    text(int(yValue), leftPad - 10, yOnScreen);
  }

  for (int i = 0; i < totalBars; i++) {
    float barHeight  = map(flightCounts[i], 0, tallestBar, 0, chartHeight);
    float xOnScreen  = leftPad + i * barWidth;
    float yOnScreen  = topPad + chartHeight - barHeight;

    if (i == totalBars - 1) fill(200, 80, 80);
    else fill(70, 130, 200);
    stroke(255);
    strokeWeight(1);
    rect(xOnScreen, yOnScreen, barWidth - 2, barHeight);

    if (flightCounts[i] > 0) {
      noStroke();
      fill(30);
      textAlign(CENTER, BOTTOM);
      textSize(11);
      text(flightCounts[i], xOnScreen + barWidth / 2, yOnScreen - 3);
    }

    noStroke();
    fill(50);
    textAlign(CENTER, TOP);
    textSize(11);
    text(xLabels[i], xOnScreen + barWidth / 2, topPad + chartHeight + 8);
  }

  stroke(100);
  strokeWeight(1.5);
  line(leftPad, topPad + chartHeight, leftPad + chartWidth, topPad + chartHeight);
  line(leftPad, topPad,               leftPad,               topPad + chartHeight);

  noStroke();
  fill(20);
  textAlign(CENTER, TOP);
  textSize(16);
  text("Flight Arrival Lateness — Frequency Chart", width / 2, 18);

  fill(50);
  textSize(12);
  textAlign(CENTER, BOTTOM);
  text("Minutes Late", width / 2, height - 5);

  pushMatrix();
  translate(15, topPad + chartHeight / 2);
  rotate(-HALF_PI);
  textAlign(CENTER, CENTER);
  textSize(12);
  text("Number of Flights", 0, 0);
  popMatrix();

  noStroke();
  fill(100);
  textAlign(RIGHT, TOP);
  textSize(11);
  text("Total late flights (>= 15 min): " + totalLateFlights, width - rightPad, topPad);
}
