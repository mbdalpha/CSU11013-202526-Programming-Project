/*
CHANGELOG:
K. Ji, Created FlightSearchSystem [further details need to be added by him], XX:XX, XX/XX/2026
T. Byrne, Ports FSS to use the Kryo system. In this process, main was renamed to FlightDataHelper, its proformance testing logic was removed, and was made into a class, 15:40, 25/03/2026

*/

import java.util.HashMap;
import java.util.List;

ArrayList<Flight> allFlights = new ArrayList<Flight>();
ArrayList<Flight> searchResults = new ArrayList<Flight>();
HashMap<String, PVector> airportCoords = new HashMap<String, PVector>(); 

String fromInput = "";
String toInput = "";
int activeBox = 0; 
boolean showResults = false;
float scrollOffset = 0, targetOffset = 0, easing = 0.15;

Flight selectedFlight = null; 
PImage american_Map;
HashMap<String, PImage> logos = new HashMap<String, PImage>();

void setup() {
  size(1200, 800);
  american_Map = loadImage("images/American Map.png");
  
  String[] airlineCodes = {"AA", "UA", "DL", "F9", "AS", "B6", "G4", "HA", "NK", "WN"}; 
  for (String code : airlineCodes) {
    logos.put(code, loadImage("images/" + code + ".png"));
  }
  
  loadAirportLocations();
  
  FlightDataHelper helper = new FlightDataHelper();
  String dataDir = helper.findDataDir();
  ReadCSV csv = new ReadCSV(dataDir + "flights_full.csv");
  allFlights = new ArrayList<Flight>(csv.getFlights());
}

void loadAirportLocations() {
  String[] lines = loadStrings("airports_location.csv");
  for (int i = 1; i < lines.length; i++) {
    String[] cols = lines[i].split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
    
    if (cols.length >17) {
      String code = cols[0].replaceAll("\"", "").trim();
      float x = float(cols[17].trim());            
      float y = float(cols[10].trim());  
      
      airportCoords.put(code, new PVector(x, y));
    }
  }
}

void draw() {
  background(10, 25, 45); 
  
  if (american_Map != null) {
    image(american_Map, 20, 130, 830, 549.6);
  }
  
  if (selectedFlight != null) {
    drawConnection(selectedFlight);
  }
  
  float dx=targetOffset-scrollOffset;
  scrollOffset+=dx*easing;
  
  drawHeaderSearch();
  if (showResults) {
    drawResultsPanel();
  }
}

void drawHeaderSearch() {
  fill(255);
  noStroke();
  rect(50, 40, 800, 70, 10); 
  stroke(200);
  line(300, 50, 300, 100);
  fill(100);
  textSize(12);
  text("From (Origin)", 70, 60);
  text("To (Dest)", 320, 60);
  fill(0);
  textSize(18);
  text(fromInput + (activeBox == 1 ? "|" : ""), 70, 90);
  text(toInput + (activeBox == 2 ? "|" : ""), 320, 90);
  fill(0, 120, 255);
  rect(870, 40, 150, 70, 10);
  fill(255);
  textAlign(CENTER, CENTER);
  text("SEARCH", 945, 75);
  textAlign(LEFT, BASELINE);
}

void drawConnection(Flight f) {
  PVector start = airportCoords.get(f.origin);
  PVector end = airportCoords.get(f.dest);
  
  if (start != null && end != null) {
    stroke(100, 200, 255, 150);
    strokeWeight(3);
    line(start.x, start.y, end.x, end.y);
    
    noStroke();
    fill(0, 214, 206); 
    ellipse(start.x, start.y, 10, 10);
    fill(255, 161, 0); 
    ellipse(end.x, end.y, 10, 10);
    
    fill(255);
    textSize(14);
    text(f.origin, start.x + 12, start.y);
    text(f.dest, end.x + 12, end.y);
  }
}

void drawResultsPanel() {
  fill(255, 25); 
  rect(870, 130, 310, 640, 10);
  fill(255);
  textSize(16);
  text("Results: " + searchResults.size(), 880, 160);
  
  push();
  clip(870,170,310,600);
  
  for(int i=0;i<searchResults.size();i++){
    float yPos=170+(i*75)+scrollOffset;
    
    if(yPos>100&&yPos<800){
      Flight f = searchResults.get(i);
      fill(255, 40);
      noStroke();
      rect(880, yPos, 290, 65, 8); 
      
      fill(255);
      textSize(13);
      text(f.origin + " → " + f.dest, 895, yPos + 25);
      textSize(11);
      fill(200);
      text("DATE: " + f.flDate, 895, yPos + 45);
      text("AIRLINE: " + f.carrier, 1050, yPos + 45);

      PImage logoImg = logos.get(f.carrier);
      if (logoImg != null) {
        image(logoImg, 1120, yPos + 12, 40, 40);
      } else {
        fill(255, 100);
        text(f.carrier, 1120, yPos + 35);
      }
    }
  }
  noClip();
  pop();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  scrollOffset -= e * 30;
  
  float totalContentHeight = searchResults.size() * 65;
  float visibleHeight = 550;
  float maxScroll = -(totalContentHeight - visibleHeight);
  
  if (maxScroll > 0) maxScroll = 0;
  scrollOffset = constrain(scrollOffset, maxScroll, 0);
}

void mousePressed() {
  if (mouseX > 50 && mouseX < 300 && mouseY > 40 && mouseY < 110) activeBox = 1;
  else if (mouseX > 300 && mouseX < 800 && mouseY > 40 && mouseY < 110) activeBox = 2;
  else if (mouseX > 870 && mouseX < 1020 && mouseY > 40 && mouseY < 110) {
    scrollOffset = 0;
    performSearch();
    showResults = true;
  } 
  else activeBox = 0;
}

void keyPressed() {
  if (activeBox == 1) {
    if (key == BACKSPACE && fromInput.length() > 0) fromInput = fromInput.substring(0, fromInput.length()-1);
    else if (key != CODED && key != ENTER) fromInput += key;
  } else if (activeBox == 2) {
    if (key == BACKSPACE && toInput.length() > 0) toInput = toInput.substring(0, toInput.length()-1);
    else if (key != CODED && key != ENTER) toInput += key;
  }
  if (key == ENTER) { 
    scrollOffset = 0;
    performSearch(); 
    showResults = true; 
  }
}

void performSearch() {
  searchResults.clear();
  String sF = fromInput.toUpperCase().trim();
  String sT = toInput.toUpperCase().trim();
  for (Flight f : allFlights) {
    boolean mF = sF.isEmpty() || f.origin.contains(sF);
    boolean mT = sT.isEmpty() || f.dest.contains(sT);
    if (mF && mT && !(sF.isEmpty() && sT.isEmpty())) searchResults.add(f);
  }
  
  if (searchResults.size() > 0) {
    selectedFlight = searchResults.get(0);
  } else {
    selectedFlight = null;
  }
}
