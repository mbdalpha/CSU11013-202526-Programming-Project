import java.util.HashMap;

ArrayList<Flight> allFlights = new ArrayList<Flight>();
ArrayList<Flight> searchResults = new ArrayList<Flight>();
HashMap<String, PVector> airportCoords = new HashMap<String, PVector>();

String airportInput = "";
boolean activeBox = false;
boolean showResults = false;
float scrollOffset = 0;
float easing = 0.15;
float targetOffset = 0;

Flight selectedFlight = null;
PImage american_Map;
HashMap<String, PImage> logos = new HashMap<String, PImage>();

void setup() {
  size(1200, 800);
  american_Map = loadImage("American Map.png");

  String[] airlineCodes = {"AA", "UA", "DL", "F9", "AS", "B6", "G4", "HA", "NK", "WN"};
  for (String code : airlineCodes) 
  {
    logos.put(code, loadImage(code + ".png"));
  }

  loadAirportLocations();

  String[] lines = loadStrings("flights2k(1) (1).csv");
  for (int i = 1; i < lines.length; i++) 
  {
    if (lines[i].trim().length() > 0) 
    {
      allFlights.add(new Flight(lines[i]));
    }
  }
}

void loadAirportLocations() {
  String[] lines = loadStrings("airports_location.csv");
  for (int i = 1; i < lines.length; i++) 
  {
    String[] cols = lines[i].split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
    if (cols.length > 17) 
    {
      String code = cols[0].replaceAll("\"", "").trim();
      float x = float(cols[17].trim());
      float y = float(cols[10].trim());
      airportCoords.put(code, new PVector(x, y));
    }
  }
}

void draw() {
  background(10, 25, 45);

  if (american_Map != null) 
  {
    image(american_Map, 20, 130, 830, 549.6);
  }

  if (airportInput.length() > 0) 
  {
    String code = airportInput.toUpperCase().trim();
    PVector pos = airportCoords.get(code);
    if (pos != null) {
      noStroke();
      fill(0, 214, 206);
      ellipse(pos.x, pos.y, 14, 14);
      noFill();
      stroke(0, 214, 206, 120);
      strokeWeight(2);
      ellipse(pos.x, pos.y, 24, 24);
      noStroke();
      fill(255);
      textSize(14);
      text(code, pos.x + 14, pos.y + 5);
      
    }
  }


  drawHeaderSearch();

  if (showResults) 
  {
    drawResultsPanel();
  }
}



void drawHeaderSearch() 
{
  fill(255);
  noStroke();
  rect(50, 40, 500, 70, 10);
  fill(100);
  textSize(12);
  text("Airport Code (e.g. JFK)", 70, 60);
  fill(0);
  textSize(18);
  text(airportInput + (activeBox ? "|" : ""), 70, 90);
  fill(0, 120, 255);
  noStroke();
  rect(570, 40, 150, 70, 10);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("SEARCH", 645, 75);
  textAlign(LEFT, BASELINE);
}

void drawResultsPanel() {
  fill(255, 25);
  noStroke();
  rect(870, 130, 310, 640, 10);
  fill(255);
  textSize(16);
  text("Results: " + searchResults.size(), 880, 160);

  push();
  clip(870, 170, 310, 600);

  for (int i = 0; i < searchResults.size(); i++) 
  {
    float yPos = 170 + (i * 75) + scrollOffset;

    if (yPos > 100 && yPos < 800) 
    {
      Flight f = searchResults.get(i);

      fill(255, 40);
      noStroke();
      rect(880, yPos, 290, 65, 8);

      fill(255);
      textSize(13);
      text(f.origin + " → " + f.dest, 895, yPos + 25);

      fill(200);
      textSize(11);
      text("DATE: " + f.date, 895, yPos + 45);
      text("AIRLINE: " + f.airline, 1050, yPos + 45);

      PImage logoImg = logos.get(f.airline);
      if (logoImg != null) 
      {
        image(logoImg, 1120, yPos + 12, 40, 40);
      } 
      else 
      {
        fill(255, 100);
        textSize(11);
        text(f.airline, 1120, yPos + 35);
      }
    }
  }

  noClip();
  pop();
}

void mouseWheel(MouseEvent event) {
  if (!showResults) return;
  float e = event.getCount();
  scrollOffset -= e * 30;

  float totalContentHeight = searchResults.size() * 75;
  float visibleHeight = 550;
  float maxScroll = -(totalContentHeight - visibleHeight);

  if (maxScroll > 0) 
  {
    maxScroll = 0;
  }
  scrollOffset = constrain(scrollOffset, maxScroll, 0);
}

void mousePressed() {
  if (mouseX > 50 && mouseX < 550 && mouseY > 40 && mouseY < 110) 
  {
    activeBox = true;
  }
  else if (mouseX > 570 && mouseX < 720 && mouseY > 40 && mouseY < 110) 
  {
    scrollOffset = 0;
    performSearch();
    showResults = true;
  }
  else 
  {
    activeBox = false;
  }
}

void keyPressed() {
  if (!activeBox) return;

  if (key == BACKSPACE && airportInput.length() > 0) 
  {
    airportInput = airportInput.substring(0, airportInput.length() - 1);
  } 
  else if (key == ENTER) 
  {
    scrollOffset = 0;
    performSearch();
    showResults = true;
  } 
  else if (key != CODED) 
  {
    airportInput += key;
  }
}

void performSearch() {
  searchResults.clear();
  String s = airportInput.toUpperCase().trim();

  if (s.isEmpty()) return;

  for (Flight f : allFlights) 
  {
    if (f.origin.equals(s) || f.dest.equals(s)) 
    {
      searchResults.add(f);
    }
  }
}

class Flight {
  String date, airline, origin, dest;

  Flight(String line) 
  {
    String[] cols = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
    if (cols.length >= 8) {
      this.date    = cols[0].trim();
      this.airline = cols[1].trim();
      this.origin  = cols[3].replaceAll("\"", "").trim();
      this.dest    = cols[7].replaceAll("\"", "").trim();
    }
  }
}
