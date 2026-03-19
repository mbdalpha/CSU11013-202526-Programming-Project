/*
CHANGELOG:
K. Ji, Impliaments SkyScanner style display for flights, 16:40, 19/03/2026
T. Byrne, Gets compiling on path to port over OpenCSV usage, XX:XX, 19/03/2026

*/

ArrayList<Flight> allFlights=new ArrayList<Flight>();
ArrayList<Flight> searchResults=new ArrayList<Flight>();

String fromInput="";
String toInput="";
int activeBox=0; 
boolean showResults=false;
float scrollOffset=0; 
float targetOffset=0;
float easing=0.15;

void setup(){
  String dataDir = findDataDir();

  println("=== CSV Loading Performance Test ===\n");
  println(String.format("%-20s %10s %12s", "File", "Rows", "Time (ms)"));
  println("----------------------------------------------");

  for (String file : DATA_FILES) {
    String path = dataDir + file;
    if (!new File(path).exists()) {
      println(String.format("%-20s %10s %12s", file, "-", "NOT FOUND"));
      continue;
    }

    long start = System.nanoTime();
    ReadCSV csv = new ReadCSV(path);
    long elapsed = (System.nanoTime() - start) / 1_000_000;

    println(String.format("%-20s %,10d %,10d ms", file, csv.getFlights().size(), elapsed));
  }

  // sort and print using first available file
  String firstPath = null;
  for (String file : DATA_FILES) {
    String path = dataDir + file;
    if (new File(path).exists()) {
      firstPath = path;
      break;
    }
  }
  //firstPath = dataDir + DATA_FILES[3]; // makes it use the largest for sorting, for testing mainly - allow user to change in future?

  if (firstPath != null) {
    ReadCSV csv = new ReadCSV(firstPath);
    SortFlights sorter = new SortFlights();

    List<Flight> flights = csv.getFlights();
  }

  size(1200,800);
  /*
  String[] lines=loadStrings("flights2k.csv"); 
  for(int i=1;i<lines.length;i++){
    if(lines[i].trim().length()>0){
      allFlights.add(new Flight(lines[i]));
    }
  }
  */
}

void draw() {
  background(10, 25, 45); 
  
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

void drawResultsPanel() {
  fill(255, 15); 
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
      text("DATE: " + f.date, 895, yPos + 45);
      text("AIRLINE: " + f.airline, 980, yPos + 45);
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


// TODO: convert this to binary search
void performSearch() {
  searchResults.clear();
  String sF = fromInput.toUpperCase().trim();
  String sT = toInput.toUpperCase().trim();
  for (Flight f : allFlights) {
    boolean matchF = sF.isEmpty() || f.origin.contains(sF);
    boolean matchT = sT.isEmpty() || f.dest.contains(sT);
    if (matchF && matchT && !(sF.isEmpty() && sT.isEmpty())) {
      searchResults.add(f);
    }
  }
}

/*
class Flight {
  String date, airline, origin, dest;
  Flight(String line) {
    String[] cols = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
    if (cols.length >= 8) {
      this.date = cols[0].trim();   
      this.airline = cols[1].trim(); 
      this.origin = cols[3].replaceAll("\"", "").trim(); 
      this.dest = cols[7].replaceAll("\"", "").trim();   
    }
  }
}
*/











// carryovers from main.pde

String findDataDir() {
  if (new File(sketchPath("flight_tables")).exists())
    return sketchPath("flight_tables") + "/";
  if (new File(sketchPath("../flight_tables")).exists())
    return sketchPath("../flight_tables") + "/";
  println("Warning: could not find flight_tables directory");
  return sketchPath("flight_tables") + "/";
}

int getLateMinutes(Flight f) {
  if (f.arrTime == null || f.arrTime.isEmpty() || f.crsArrTime == null || f.crsArrTime.isEmpty()) return 0;
  int actual = Integer.parseInt(f.arrTime.trim());
  int sched = Integer.parseInt(f.crsArrTime.trim());
  return ((actual / 100) * 60 + (actual % 100)) - ((sched / 100) * 60 + (sched % 100));
}

ArrayList<Airport> getAirports(List<Flight> flightList){
  ArrayList<Airport> airports = new ArrayList<Airport>();
  for (Flight f : flightList) {
    String[] ap = {f.origin, f.dest};
    String[] cities = {f.originCity, f.destCity};
    for(int j = 0; j < ap.length; j++){
      String a = ap[j];
      int position = -1;
      for(int i = 0; i < airports.size(); i++){
        if(airports.get(i).aberviation.equals(a)){
          position = i;
          airports.get(i).flightCount++;
          airports.get(i).cancelledOrDiverted += (Integer.parseInt(f.cancelled) + Integer.parseInt(f.diverted));
        }
      }
      if(position == -1){
        Airport newAirport = new Airport();
        newAirport.aberviation = a;
        newAirport.city = cities[j];
        newAirport.flightCount = 1;
        newAirport.cancelledOrDiverted = (Integer.parseInt(f.cancelled) + Integer.parseInt(f.diverted));
        airports.add(newAirport);
      }
    }
  }
  return airports;
}
