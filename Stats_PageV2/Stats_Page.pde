//array printed out on Page 1 from left to right for both 'busyAirportNames'
//and 'busyValues'. sort from largest to smallest from left to right for top 20
//busiest airports and their respective values.
String[] busyAirportNames = {"LAX", "LHR", "JFK", "CDG", "DXB", "LAX", "LHR", "JFK", "CDG", "DXB"};
int[] busyValues = {300, 800, 1200, 600, 1500, 300, 800, 1200, 600, 1500};

//array printed out on Page 2 from top to bottom for both 'leastReliableAirportNames'
//and 'NoOfFlightsCancelledOrDelayed'. Reading array from left to right shows the
//Least reliable to 10th least reliable airport.
String[] leastReliableAirportNames = {"LAX", "LHR", "JFK", "CDG", "DXB", "LAX", "LHR", "JFK", "CDG", "DXB"};
//number of flights cancelled or delayed, position of integer in array corresponds to index
//of airports in the String array
int[] NoOfFlightsCancelledOrDelayed = {232, 500, 1000, 10, 100, 232, 500, 1000, 10, 100};


int[] Ranking = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

int flightDataSize = 2000;  // value can be altered to match data size of CSV file

int step = flightDataSize / 10;
int spacing1 = 40;  
int spacing2 = 60;
int startX = 195; 
int startY = 200;  
int currentPage = 1;
int totalPages = 3;
int totalAirports = 20;

int[] flightCounts;
String[] xLabels;
int totalBars = 15;
int totalLateFlights = 0;

Location[] theLocation = new Location[20];
Marking marks;
Rank[] theRank = new Rank[10];
pageCounter thePageCounter;

void setup() {

  background(255);
  size(1200, 800);
  
  textFont(createFont("Arial", 12));
  flightCounts = new int [totalBars];
  xLabels = new String[totalBars];
  
  thePageCounter = new pageCounter();
    
  marks = new Marking(120, 660, 540, flightDataSize, step);
  
    for (int i = 0; i < totalAirports; i++) {
      int index = i % busyValues.length; 
      int xPos = startX + i * spacing1;
    
      theLocation[i] = new Location(busyValues[index], xPos, busyAirportNames[index]);
    }
    
    for (int i = 0; i < 10; i++) {
       int yPos = (startY + i * spacing2) - 10;
       theRank[i] = new Rank(Ranking[i], yPos);
    }
    
    for (int i = 0; i < totalBars - 1; i++) {
      int rangeStart = 15 + i * 20;
      int rangeEnd = rangeStart + 20;
      xLabels[i] = rangeStart + "-" + rangeEnd;
    }
    
    xLabels[totalBars - 1] = "300+";

    loadCSVData("flights2k(1) (1) (2).csv");

  }

// Rians code to read CSV file, alter only if necessary

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
  drawButtons();
  
  if (currentPage == 1) {
    drawPage1();
  } else if (currentPage == 2) {
    drawPage2();
  } else if (currentPage == 3) {
    drawPage3();
  }
    
  thePageCounter.display(currentPage, totalPages);
    
}

void drawButtons() {
  
  textAlign(CENTER, CENTER);
  
  if(currentPage!=1) {
    fill(200);
    //rect(40, 40, 140, 60);
    rect(200, 40, 140, 60, 10);
    fill(0);
    textSize(32);
    text("Prev", 260, 70);
  }

  if(currentPage!=3) {
    fill(200);
    rect(width - 180, 40, 140, 60, 10);
    fill(0);
    textSize(32);
    text("Next", width - 120, 70);
  }
  
    fill(200);
    rect(40, 700, 140, 60, 10);
    fill(0);
    textSize(32);
    text("Back", 100, 730);
}

void mousePressed() {
  if (mouseX > 200 && mouseX < 360 &&
      mouseY > 40 && mouseY < 100) {
    
    currentPage--;
    if (currentPage <= 1) {
      currentPage = 1; 
    }
  }

  if (mouseX > width - 180 && mouseX < width - 40 &&
      mouseY > 40 && mouseY < 100) {
    
    currentPage++;
    if (currentPage >= totalPages) {
      currentPage = totalPages;
    }
  }
  
  if (mouseX > 40 && mouseX < 180 &&
      mouseY > 700 && mouseY < 760) {
    
      exit();
  }
}

void drawPage1() {

  int leftPad = 120;
  int rightPad = 80;
  int topPad = 120;
  int bottomPad = 140;

  int chartWidth  = width  - leftPad - rightPad;
  int chartHeight = height - topPad  - bottomPad;

  float bottomY = topPad + chartHeight;

  int maxVal = flightDataSize;
  for (int v : busyValues) {
    if (v > maxVal) maxVal = v;
  }

  stroke(100);
  line(leftPad, bottomY, leftPad + chartWidth, bottomY);
  line(leftPad, topPad, leftPad, bottomY);
  
  marks.draw();


  float barWidth = chartWidth / (float) totalAirports;
  
  for (int i = 0; i < totalAirports; i++) {
    float x = leftPad + i * barWidth;
    theLocation[i].x = x;
    theLocation[i].draw(bottomY, chartHeight, maxVal, barWidth);
  }

  fill(0);
  textAlign(CENTER);
  textSize(32);
  text("Busiest Airport Bar Chart", width / 2, 60);

  textSize(25);
  text("Airport", width / 2, height - 40);

  pushMatrix();
  translate(40, topPad + chartHeight / 2);
  rotate(-HALF_PI);
  textAlign(CENTER, CENTER);
  text("Number of Flights", 0, 0);
  popMatrix();
}


void drawPage2() {
  
  fill(255);
  stroke(220);
  strokeWeight(1);
  rect(232, startY - 85, 800, 625, 10);
  
  line(375, startY - 50, 375, 740);
  line(550, startY - 50, 550, 740);
  
  for (int i = 0; i < 9; i++) {
    int tempStartY = 210;
    line(232, (tempStartY + i * spacing2), 1032, (tempStartY + i * spacing2));

  } 
  
  fill(18, 136, 179);
  rect(230, startY - 85, 805, 45, 10);
  
  fill(0);
  textAlign(CENTER);
  textSize(32);
  text("Least reliable Airport Ranking", width / 2, 60);
  
  text("Ranking", 310, startY - 50);
  text("Airport", 460, startY - 50);
  text("No of flights cancelled / delayed", 790, startY - 50);

  for (int i = 0; i < 10; i++) {
    theRank[i].draw();
    
    int yPos = (startY + i * spacing2) - 10;
    text(leastReliableAirportNames[i], 460, yPos);
    text(NoOfFlightsCancelledOrDelayed[i], 790, yPos);
  }
  
}






// Rians code for Flight Arrival Lateness - Frequency Chart

void drawPage3() {
  
  fill(0);
  textAlign(CENTER);
  textSize(32);
  text("Flight Arrival Lateness — Frequency Chart", width / 2 + 70, 60);


  int leftPad = 80, rightPad = 30, topPad = 150, bottomPad = 90;
  int chartWidth = width  - leftPad - rightPad;
  int chartHeight = height - topPad  - bottomPad - 35;

  int tallestBar = 0;
  for (int count : flightCounts) if (count > tallestBar) tallestBar = count;

  float barWidth = (float)chartWidth / totalBars;

  int numberOfYLines = 6;
  for (int i = 0; i <= numberOfYLines; i++) 
  {
    float yValue = map(i, 0, numberOfYLines, 0, tallestBar);
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

  for (int i = 0; i < totalBars; i++)
  {
    float barHeight = map(flightCounts[i], 0, tallestBar, 0, chartHeight);
    float xOnScreen = leftPad + i * barWidth;
    float yOnScreen  = topPad + chartHeight - barHeight;

    if (i == totalBars - 1) 
    {
      fill(200, 80, 80);
    }
    else 
    {
      fill(70, 130, 200);
    }
    stroke(255);
    strokeWeight(1);
    rect(xOnScreen, yOnScreen, barWidth - 2, barHeight);

    if (flightCounts[i] > 0) 
    {
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
  line(leftPad, topPad, leftPad, topPad + chartHeight);

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
