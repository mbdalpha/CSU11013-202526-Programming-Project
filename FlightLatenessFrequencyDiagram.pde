int[] flightCounts;
String[] xLabels;
int totalBars = 15;
int totalLateFlights = 0;

void setup() {
  size(1200, 800);
  textFont(createFont("Arial", 12));
  flightCounts = new int[totalBars];
  xLabels = new String[totalBars];

  for (int i = 0; i < totalBars - 1; i++) 
  {
    int rangeStart = 15 + i * 20;
    int rangeEnd = rangeStart + 20;
    xLabels[i] = rangeStart + "-" + rangeEnd;
  }
  xLabels[totalBars - 1] = "300+";

  loadCSVData("flights100k(1) (1).csv");
}

void loadCSVData(String filename) {
  Table table = loadTable(filename, "header");

  for (TableRow row : table.rows()) {
    if (row.getString("CANCELLED").trim().startsWith("1"))
    {
      continue;
    }
    if (row.getString("DIVERTED").trim().startsWith("1"))
    {
      continue;
    }

    String actualArrival = row.getString("ARR_TIME").trim();
    String scheduledArrival = row.getString("CRS_ARR_TIME").trim();
    if (actualArrival.length() == 0 || scheduledArrival.length() == 0)
    {
      continue;
    }
    int scheduledHHMM = int(float(scheduledArrival));
    int actualHHMM = int(float(actualArrival));
    int scheduledMins = (scheduledHHMM / 100) * 60 + (scheduledHHMM % 100);
    int actualMins = (actualHHMM    / 100) * 60 + (actualHHMM    % 100);

    float minutesLate = actualMins - scheduledMins;

    if (minutesLate < -720) 
    {
      minutesLate += 1440;
    }
    if (minutesLate >  720) 
    {
      minutesLate -= 1440;
    }

    if (minutesLate < 15) 
    {
      continue;
    }


    if (minutesLate >= 300) 
    {
      flightCounts[totalBars - 1]++;
    } 
    else 
    {
      int barIndex = int((minutesLate - 15) / 20);
      if (barIndex >= 0 && barIndex < totalBars - 1) 
      {
        flightCounts[barIndex]++;
      }
    }
  }
  for (int i = 0; i < totalBars; i++) 
  {
    totalLateFlights += flightCounts[i];
  }
}

void draw() {
  background(255);

  int leftPad = 80, rightPad = 30, topPad = 150, bottomPad = 90;
  int chartWidth = width  - leftPad - rightPad;
  int chartHeight = height - topPad  - bottomPad;

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

  noStroke();
  fill(20);
  textAlign(CENTER, TOP);
  textSize(16);
  text("Flight Arrival Lateness — Frequency Chart", width / 2, topPad);

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
