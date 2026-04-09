/*
CHANGELOG:
[Other teammates]
T. Byrne, gets the system working all together while attempting to follow some OOP prinicpals to break up the files compared to previous impliamention of them all combined, 02:20, 03/04/2026
T. Byrne, makes the flight listings all use Kryo again, 12:30, 03/04/2026
T. Byrne, fixes statistics pages not loading properly, 11:00, 08/04/2026
T. Byrne, Defer loading Statistics page until it is clicked in order to reduce load time, 9:30, 09/04/2026
*/


//array printed out on Page 1 from left to right for both 'busyAirportNames'
//and 'busyValues'. sort from largest to smallest from left to right for top 20
//busiest airports and their respective values.
String[] busyAirportNames;
int[] busyValues;

//array printed out on Page 2 from top to bottom for both 'leastReliableAirportNames'
//and 'NoOfFlightsCancelledOrDelayed'. Reading array from left to right shows the
//Least reliable to 10th least reliable airport.
String[] leastReliableAirportNames;
//number of flights cancelled or delayed, position of integer in array corresponds to index
//of airports in the String array
int[] NoOfFlightsCancelledOrDelayed;


boolean statsInitialized = false;
int[] Ranking = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

int flightDataSize;

int step;
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

void initStats(){
    textFont(createFont("Arial", 12));
    flightDataSize = allFlights.size();
    step = flightDataSize / 10;
    flightCounts = new int [totalBars];
    xLabels = new String[totalBars];

    thePageCounter = new pageCounter();

    // compute busiest airports from actual flight data
    SortFlights sorter = new SortFlights();
    List<Airport> busiest = sorter.sortByBusiest(allFlights, SortFlights.DESCENDING);
    int count = min(totalAirports, busiest.size());
    busyAirportNames = new String[count];
    busyValues = new int[count];
    for (int i = 0; i < count; i++) {
      busyAirportNames[i] = busiest.get(i).aberviation;
      busyValues[i] = busiest.get(i).flightCount;
    }

    // compute least reliable airports from actual flight data
    List<Airport> leastReliable = sorter.sortByReliability(allFlights, SortFlights.DESCENDING);
    int reliableCount = min(10, leastReliable.size());
    leastReliableAirportNames = new String[reliableCount];
    NoOfFlightsCancelledOrDelayed = new int[reliableCount];
    for (int i = 0; i < reliableCount; i++) {
      leastReliableAirportNames[i] = leastReliable.get(i).aberviation;
      NoOfFlightsCancelledOrDelayed[i] = leastReliable.get(i).cancelledOrDiverted;
    }

    marks = new Marking(120, 660, 540, flightDataSize, step);

    for (int i = 0; i < count; i++) {
      int xPos = startX + i * spacing1;
      theLocation[i] = new Location(busyValues[i], xPos, busyAirportNames[i]);
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

    computeLateness(allFlights);
}

boolean statsLoading = false;

void drawStats(){
    if (!statsInitialized) {
      if (!statsLoading) {
        // first frame: draw loading screen, set flag so next frame runs init
        statsLoading = true;
        background(10, 25, 45);
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(28);
        text("Loading Statistics...", width / 2, height / 2);
        return;
      }
      // second frame: actually run the heavy init
      initStats();
      statsInitialized = true;
      statsLoading = false;
    }
    background(10,25,45);
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

void statsMousePressed(){
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

          flightFinderPage = true;
          for (int j = 0; j < pageCount; j++) {
            pages[j].selected = false;
          }
          pages[0].selected = true;
      }
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

void drawPage1() {

  int leftPad = 120;
  int rightPad = 80;
  int topPad = 120;
  int bottomPad = 140;

  int chartWidth  = width  - leftPad - rightPad;
  int chartHeight = height - topPad  - bottomPad;

  float bottomY = topPad + chartHeight;

  int maxVal = 0;
  for (int v : busyValues) {
    if (v > maxVal) maxVal = v;
  }

  stroke(100);
  line(leftPad, bottomY, leftPad + chartWidth, bottomY);
  line(leftPad, topPad, leftPad, bottomY);

  marks.draw();


  float barWidth = chartWidth / (float) busyValues.length;

  for (int i = 0; i < busyValues.length; i++) {
    float x = leftPad + i * barWidth;
    theLocation[i].x = x;
    theLocation[i].draw(bottomY, chartHeight, maxVal, barWidth);
  }

  fill(255);
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

  fill(255);
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

void drawPage3() {

  fill(255);
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
    fill(255);
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
      fill(255);
      textAlign(CENTER, BOTTOM);
      textSize(11);
      text(flightCounts[i], xOnScreen + barWidth / 2, yOnScreen - 3);
    }

    noStroke();
    fill(255);
    textAlign(CENTER, TOP);
    textSize(11);
    text(xLabels[i], xOnScreen + barWidth / 2, topPad + chartHeight + 8);
  }

  stroke(100);
  strokeWeight(1.5);
  line(leftPad, topPad + chartHeight, leftPad + chartWidth, topPad + chartHeight);
  line(leftPad, topPad, leftPad, topPad + chartHeight);

  fill(255);
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
  fill(255);
  textAlign(RIGHT, TOP);
  textSize(11);
  text("Total late flights (>= 15 min): " + totalLateFlights, width - rightPad, topPad);
}

void computeLateness(ArrayList<Flight> flights) {
  for (Flight f : flights) {
    if (f.cancelled.trim().startsWith("1")) continue;
    if (f.diverted.trim().startsWith("1")) continue;

    String actualArrival    = f.arrTime.trim();
    String scheduledArrival = f.crsArrTime.trim();
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
