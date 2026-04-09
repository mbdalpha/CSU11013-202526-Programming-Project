/*
CHANGELOG:
[Other teammates]
T. Byrne, FlightSorterPage to actually work and be able to sort and search, 12:30, 08/04/2026
*/

DateWidget[] dates = new DateWidget[31];
String from = "From: ";
String too = "To: "; //too because to leads to syntax error
boolean fromSelected = false;
boolean toSelected = false;
int fromDate = 0;
int toDate = 0;

float widgetW = 200;
float widgetH = 60;
float dateWidgetX = 550;
float dateWidgetY = 160;
float lateWidgetX = 300;
float lateWidgetY = 160;
float searchWidgetX = 900;
float searchWidgetY = 70;

float startX2 = 360;
float startY2 = 380;
float radius = 40;
float gap = 20;

float fromX = 340;
float fromY = 330;
float toX = 620;
float toY = 330;
float clearX = 640;
float clearY = 680;

float ascWidgetX = 100;
float ascWidgetY = 300;
float ascWidgetW = 50;
float ascWidgetH = 150;
float desWidgetX = 100;
float desWidgetY = 450;

Widget duration = new Widget(dateWidgetX, dateWidgetY,
                             widgetW, widgetH, "Duration", true);
Widget lateness = new Widget(lateWidgetX, lateWidgetY,
                             widgetW, widgetH, "Lateness", true);
Widget search = new Widget(searchWidgetX, searchWidgetY,
                           widgetW, widgetH, "Search", true);
Widget clear = new Widget(clearX, clearY,
                          widgetW / 1.5, widgetH / 1.5, "clear", true);
Widget ascending = new Widget(ascWidgetX, ascWidgetY,
                              ascWidgetW, ascWidgetH, "↑", true);
Widget descending = new Widget(desWidgetX, desWidgetY,
                               ascWidgetW, ascWidgetH, "↓", true);

void initFlightSorter(){
    //Flight sorter setup

    //creates the date widgets
    for (int i = 0; i < 31; i++) {
        int date = i + 1;
        int index = i + 5; //5 offsets it so 1 starts on the 6th column (Saturday)
        int col = index % 7; //7 is the total number of columns (days in a week)
        int row = index / 7;

        float x = startX2 + col * (radius + gap);
        float y = startY2 + row * (radius + gap);

        dates[i] = new DateWidget(x, y, radius, date);
    }
}

void drawFlightSorter(){
    background(10, 25, 45);
    textSize(20);
    fill(255);

  //to draw the calendar background
    stroke(0);
    strokeWeight(2);
    rect(fromX - 110, fromY - 70, 615, 480, 10);
    fill(0);
    line(fromX - 110, fromY + 20, fromX + 505, fromY + 20);

    duration.draw();
    lateness.draw();
    clear.draw();
    ascending.draw();
    descending.draw();

  //to draw the calendar
    for (int i = 0; i < 31; i++) {
      dates[i].draw();
    }
    textAlign(LEFT);
    fill(0);
    text(from, fromX, fromY);
    text(too, toX, toY);

    float dx = targetOffset - scrollOffset;
    scrollOffset += dx * easing;

    drawHeaderSearch();

    if (showResults) {
      drawResultsPanel();
    }
}

void sorterMousePressed(){
    // text input boxes
    if (mouseX > 190 && mouseX < 520 && mouseY > 40 && mouseY < 110) {
      activeBox = 1;
    }
    else if (mouseX > 520 && mouseX < 850 && mouseY > 40 && mouseY < 110) {
      activeBox = 2;
    }
    // search button
    else if (mouseX > 870 && mouseX < 1020 && mouseY > 40 && mouseY < 110) {
      scrollOffset = 0;
      targetOffset = 0;
      performSorterSearch();
      showResults = true;
      activeBox = 0;
    }
    // IATA/City toggle
    else if (mouseX > 1035 && mouseX < 1175 && mouseY > 40 && mouseY < 110) {
      useIATAMode = !useIATAMode;
      activeBox = 0;
    }
    else {
      activeBox = 0;
    }

    // ascending/descending toggles
    if (mouseX > ascWidgetX &&
        mouseX < ascWidgetX + ascWidgetW &&
        mouseY > ascWidgetY &&
        mouseY < ascWidgetY + ascWidgetH) {
      ascending.selected = true;
      descending.selected = false;
    }
    if (mouseX > desWidgetX &&
        mouseX < desWidgetX + ascWidgetW &&
        mouseY > desWidgetY &&
        mouseY < desWidgetY + ascWidgetH) {
      ascending.selected = false;
      descending.selected = true;
    }

    // date calendar clicks
    for (int i = 0; i < 31; i++) {
        if (mouseX > dates[i].x - radius &&
            mouseX < dates[i].x + radius &&
              mouseY > dates[i].y - radius &&
              mouseY < dates[i].y + radius) {
            if (!fromSelected && !toSelected && dates[i].date < 10) {
              from = from + "0" + dates[i].date + "/01/2022";
              fromSelected = true;
              fromDate = dates[i].date;
            }
            else if (!fromSelected && !toSelected) {
              from = from + dates[i].date + "/01/2022";
              fromSelected = true;
              fromDate = dates[i].date;
            }
            else if (!toSelected && dates[i].date < 10) {
              too = too + "0" + dates[i].date + "/01/2022";
              toSelected = true;
              toDate = dates[i].date;
            }
            else if (!toSelected) {
              too = too + dates[i].date + "/01/2022";
              toSelected = true;
              toDate = dates[i].date;
            }
          }
      }
    // clear button
    if (mouseX > clear.x &&
        mouseX < clear.x + clear.w &&
        mouseY > clear.y &&
        mouseY < clear.y + clear.h) {
           fromSelected = false;
           toSelected = false;
           from = "From: ";
           too = "To: ";
           fromDate = 0;
           toDate = 0;
        }
    // duration/lateness sort mode toggles
    if (mouseX > duration.x &&
        mouseX < duration.x + duration.w &&
        mouseY > duration.y &&
        mouseY < duration.y + duration.h) {
          if (duration.selected == true) {
            duration.selected = false;
          }
          else {
            duration.selected = true;
            lateness.selected = false;
          }
        }
    if (mouseX > lateness.x &&
        mouseX < lateness.x + lateness.w &&
        mouseY > lateness.y &&
        mouseY < lateness.y + lateness.h) {
          if (lateness.selected == true) {
            lateness.selected = false;
          }
          else {
            lateness.selected = true;
            duration.selected = false;
          }
        }
}

void sorterKeyPressed() {
    if (activeBox == 1) {
      fromInput = updateTextInput(fromInput);
    }
    else if (activeBox == 2) {
      toInput = updateTextInput(toInput);
    }

    if (key == ENTER || key == RETURN) {
      scrollOffset = 0;
      targetOffset = 0;
      performSorterSearch();
      showResults = true;
    }
}

void performSorterSearch() {
    SortFlights sorter = new SortFlights();
    boolean asc = ascending.selected;

    // filter by origin/dest using same logic as performSearch
    List<Flight> filtered = new ArrayList<Flight>();
    String sF = fromInput.trim().toUpperCase();
    String sT = toInput.trim().toUpperCase();

    for (Flight f : allFlights) {
      boolean mF;
      boolean mT;

      if (useIATAMode) {
        mF = sF.isEmpty() || f.origin.toUpperCase().contains(sF);
        mT = sT.isEmpty() || f.dest.toUpperCase().contains(sT);
      } else {
        mF = sF.isEmpty() || normalizeCity(f.originCity).contains(normalizeCity(sF));
        mT = sT.isEmpty() || normalizeCity(f.destCity).contains(normalizeCity(sT));
      }

      // filter by date range using isDateInRange from FlightFinderPage
      String startStr = (fromDate > 0) ? formatJan2022Date(fromDate) : "";
      String endStr = (toDate > 0) ? formatJan2022Date(toDate) : "";
      boolean mD = isDateInRange(f.flDate, startStr, endStr);

      if (mF && mT && mD) {
        filtered.add(f);
      }
    }

    // sort by selected mode
    if (lateness.selected) {
      filtered = new ArrayList<Flight>(sorter.latenessSort(filtered, asc));
    } else if (duration.selected) {
      filtered = new ArrayList<Flight>(sorter.dateSort(filtered, asc));
    }

    searchResults = new ArrayList<Flight>(filtered);

    if (searchResults.size() > 0) {
      selectedFlight = searchResults.get(0);
    } else {
      selectedFlight = null;
    }
}
