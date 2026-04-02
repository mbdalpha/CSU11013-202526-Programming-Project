/*
CHANGELOG:
T. Byrne, Benchmarks ReadCSV loading across all flight CSV files for testing, 07:50, 19/03/2026
T. Byrne, Uses SortFlights and displays the first 20 of each sort, 08:50, 19/03/2026
T. Byrne, Adds busiest airports, 15:40, 19/03/2026
T. Byrne, Adds least reliable airports, 17:05, 19/03/2026
T. Byrne, Moves from using OpenCSV to Kryo, improving the speed it takes to load the database in memory, 15:50, 24/03/2026
T. Byrne, Strips down main.pde, so it can be used to host any classes or objects that should be shared between the different screens, mainly the CSV file loading, 10:25, 02/04/2026

*/

ArrayList<Flight> allFlights;

void setup() {
  size(1200, 800);

  ReadCSV csv = new ReadCSV(sketchPath("flight_tables/flights100k.csv"));
  allFlights = new ArrayList<Flight>(csv.getFlights());

  initFSS();
}

void draw() {
  drawFSS();
}

void mouseWheel(MouseEvent event) {
  fssMouseWheel(event);
}

void mousePressed() {
  fssMousePressed();
}

void mouseDragged() {
  fssMouseDragged();
}

void mouseReleased() {
  fssMouseReleased();
}

void keyPressed() {
  fssKeyPressed();
}
