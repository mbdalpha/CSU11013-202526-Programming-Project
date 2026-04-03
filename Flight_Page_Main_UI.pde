/*
CHANGELOG:
[Other teammates]
T. Byrne, gets the system working all together while attempting to follow some OOP prinicpals to break up the files compared to previous impliamention of them all combined, 02:20, 03/04/2026
T. Byrne, makes the flight listings all use Kryo again, 12:30, 03/04/2026
*/

import java.util.HashMap;
import java.text.SimpleDateFormat;
import java.util.Date;

// shared data — change this one line to switch dataset
String FLIGHT_CSV = "data/flights_full.csv";
ArrayList<Flight> allFlights;

// page navigation
int pageCount = 4;
Widget[] pages = new Widget[pageCount];
Widget dropDown = new Widget(0, 0, 150, 50, "Pages", false);
boolean flightFinderPage = true;
boolean statsPage = false;
boolean airportFlightsPage = false;
boolean flightSorterPage = false;

void setup() {
  size(1200, 800);

  // load csv using ReadCSV + kryo
  ReadCSV csv = new ReadCSV(sketchPath(FLIGHT_CSV));
  allFlights = new ArrayList<Flight>(csv.getFlights());

  // init each page
  initFlightFinder();
  initAirportFlights();
  initFlightSorter();
  initStats();

  // page dropdown
  for (int i = 0; i < pageCount; i++) {
    pages[i] = new Widget(0, 50 + i * 50, 150, 50,
                          Integer.toString(i), false);
  }
  pages[0].label = "Flight Finder";
  pages[1].label = "Flights by Airport";
  pages[2].label = "Flight Sorter";
  pages[3].label = "Statistics";
}

void draw() {
  background(10, 25, 45);
  textAlign(LEFT);

  if (flightFinderPage)        drawFlightFinder();
  else if (statsPage)          drawStats();
  else if (airportFlightsPage) drawAirportFlights();
  else if (flightSorterPage)   drawFlightSorter();

  // dropdown overlay
  textSize(18);
  dropDown.draw();
  if (dropDown.selected) {
    for (int i = 0; i < pageCount; i++) pages[i].draw();
  }
}
void mouseWheel(MouseEvent event) { finderMouseWheel(event); }
void mouseDragged()               { finderMouseDragged(); }
void mouseReleased()              { finderMouseReleased(); }

void mousePressed() {
  if (flightFinderPage)        finderMousePressed();
  else if (statsPage)          statsMousePressed();
  else if (airportFlightsPage) airportMousePressed();
  else if (flightSorterPage)   sorterMousePressed();

  // dropdown page-switching
  if (mouseX > dropDown.x && mouseX < dropDown.x + dropDown.w &&
      mouseY > dropDown.y && mouseY < dropDown.y + dropDown.h) {
    dropDown.selected = !dropDown.selected;
  } else if (dropDown.selected) {
    for (int i = 0; i < pageCount; i++) {
      if (mouseX > pages[i].x && mouseX < pages[i].x + pages[i].w &&
          mouseY > pages[i].y && mouseY < pages[i].y + pages[i].h) {
        flightFinderPage = (i == 0);
        airportFlightsPage = (i == 1);
        flightSorterPage = (i == 2);
        statsPage = (i == 3);
        for (int j = 0; j < pageCount; j++) pages[j].selected = false;
        pages[i].selected = true;
        dropDown.selected = false;
        break;
      }
    }
  }
}

void keyPressed() {
  if (flightFinderPage)        finderKeyPressed();
  else if (airportFlightsPage) airportKeyPressed();
}
