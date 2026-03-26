import java.util.HashMap;
import java.text.SimpleDateFormat;
import java.util.Date;

ArrayList<Flight> allFlights = new ArrayList<Flight>();
ArrayList<Flight> searchResults = new ArrayList<Flight>();
HashMap<String, PVector> airportCoords = new HashMap<String, PVector>();

String fromInput = "";
String toInput = "";
String startDateInput = "";
String endDateInput = "";

int activeBox = 0;  
boolean showResults = false;
float scrollOffset = 0, targetOffset = 0, easing = 0.15;

Flight selectedFlight = null;
PImage american_Map;
HashMap<String, PImage> logos = new HashMap<String, PImage>();

boolean showCalendar = false;
int calendarTargetBox = 0;   // 3=start date, 4=end date
int calendarX = 390;
int calendarY = 140;
int calendarW = 430;
int calendarH = 295;

boolean useIATAMode = true;

SimpleDateFormat flightFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm");
SimpleDateFormat selectedDateFormat = new SimpleDateFormat("MM/dd/yyyy");

void setup() {
  size(1200, 800);

  american_Map = loadImage("American Map.png");

  String[] airlineCodes = {"AA", "UA", "DL", "F9", "AS", "B6", "G4", "HA", "NK", "WN"};
  for (String code : airlineCodes) {
    logos.put(code, loadImage(code + ".png"));
  }

  loadAirportLocations();

  String[] lines = loadStrings("flights_full.csv");
  for (int i = 1; i < lines.length; i++) {
    if (lines[i].trim().length() > 0) {
      allFlights.add(new Flight(lines[i]));
    }
  }

  flightFormat.setLenient(false);
  selectedDateFormat.setLenient(false);
}

void draw() {
  background(10, 25, 45);

  if (american_Map != null) {
    image(american_Map, 20, 130, 830, 549.6);
  }

  if (selectedFlight != null) {
    drawConnection(selectedFlight);
  }

  float dx = targetOffset - scrollOffset;
  scrollOffset += dx * easing;

  drawHeaderSearch();

  if (showResults) {
    drawResultsPanel();
  }

  if (showCalendar) {
    drawCalendarPopup();
  }
}

void loadAirportLocations() {
  String[] lines = loadStrings("airports_location.csv");
  for (int i = 1; i < lines.length; i++) {
    String[] cols = lines[i].split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
    if (cols.length > 17) {
      String code = cols[0].replaceAll("\"", "").trim();
      float x = float(cols[17].trim());
      float y = float(cols[10].trim());
      airportCoords.put(code, new PVector(x, y));
    }
  }
}

void drawHeaderSearch() {
  fill(255);
  noStroke();
  rect(30, 40, 820, 70, 10);

  stroke(220);
  line(220, 50, 220, 100);
  line(410, 50, 410, 100);
  line(620, 50, 620, 100);

  fill(100);
  textSize(12);

  if (useIATAMode) {
    text("From (Origin)", 50, 60);
    text("To (Dest)", 240, 60);
  } else {
    text("From City", 50, 60);
    text("To City", 240, 60);
  }

  text("Start Date", 430, 60);
  text("End Date", 640, 60);

  fill(0);
  textSize(18);

  text(fromInput + (activeBox == 1 ? "|" : ""), 50, 90);
  text(toInput + (activeBox == 2 ? "|" : ""), 240, 90);

  if (startDateInput.equals("")) {
    fill(140);
    text("Select date", 430, 90);
  } else {
    fill(0);
    text(startDateInput, 430, 90);
  }

  if (endDateInput.equals("")) {
    fill(140);
    text("Select date", 640, 90);
  } else {
    fill(0);
    text(endDateInput, 640, 90);
  }

  fill(0, 120, 255);
  noStroke();
  rect(870, 40, 150, 70, 10);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(18);
  text("SEARCH", 945, 75);

  fill(255);
  rect(1035, 40, 140, 70, 10);

  fill(0, 120, 255);
  if (useIATAMode) {
    textSize(16);
    text("IATA", 1105, 65);
    textSize(11);
    text("Click to CITY", 1105, 86);
  } else {
    textSize(16);
    text("CITY", 1105, 65);
    textSize(11);
    text("Click to IATA", 1105, 86);
  }

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
  clip(870, 170, 310, 580);

  for (int i = 0; i < searchResults.size(); i++) {
    float yPos = 170 + (i * 82) + scrollOffset;

    if (yPos > 100 && yPos < 780) {
      Flight f = searchResults.get(i);

      fill(255, 40);
      noStroke();
      rect(880, yPos, 290, 72, 8);

      fill(255);
      textSize(13);
      text(f.origin + " → " + f.dest, 895, yPos + 20);

      textSize(10);
      fill(200);
      text(f.originCity + " → " + f.destCity, 895, yPos + 38);
      text("DATE: " + f.date, 895, yPos + 53);
      text("AIRLINE: " + f.airline, 895, yPos + 67);

      PImage logoImg = logos.get(f.airline);
      if (logoImg != null) {
        image(logoImg, 1120, yPos + 16, 34, 34);
      } else {
        fill(255, 120);
        text(f.airline, 1120, yPos + 38);
      }
    }
  }

  noClip();
  pop();
}

void drawCalendarPopup() {
  fill(0, 90);
  noStroke();
  rect(0, 0, width, height);

  fill(255);
  stroke(180);
  rect(calendarX, calendarY, calendarW, calendarH, 12);

  fill(0);
  textSize(22);
  textAlign(CENTER, CENTER);
  text("January 2022", calendarX + calendarW/2, calendarY + 28);

  String[] weekDays = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
  int startX = calendarX + 18;
  int startY = calendarY + 60;
  int cellW = 56;
  int cellH = 34;

  textSize(12);
  fill(80);
  for (int i = 0; i < 7; i++) {
    text(weekDays[i], startX + i*cellW + cellW/2, startY);
  }

  int offset = 6;

  for (int day = 1; day <= 31; day++) {
    int index = offset + day - 1;
    int col = index % 7;
    int row = index / 7;

    int x = startX + col * cellW;
    int y = startY + 18 + row * cellH;
    int w = cellW - 4;
    int h = cellH - 4;

    String currentDate = formatJan2022Date(day);

    if (currentDate.equals(startDateInput) || currentDate.equals(endDateInput)) {
      fill(0, 120, 255);
      stroke(0, 120, 255);
    } else {
      fill(245);
      stroke(200);
    }

    rect(x, y, w, h, 6);

    if (currentDate.equals(startDateInput) || currentDate.equals(endDateInput)) {
      fill(255);
    } else {
      fill(0);
    }

    textSize(15);
    text(day, x + w/2, y + h/2);
  }

  fill(120);
  textSize(12);
  text("Click a date to select", calendarX + calendarW/2, calendarY + calendarH - 16);

  textAlign(LEFT, BASELINE);
}

void mouseWheel(MouseEvent event) {
  if (!showResults) return;

  float e = event.getCount();
  targetOffset -= e * 30;

  float totalContentHeight = searchResults.size() * 82;
  float visibleHeight = 580;
  float maxScroll = -(totalContentHeight - visibleHeight);

  if (maxScroll > 0) maxScroll = 0;
  targetOffset = constrain(targetOffset, maxScroll, 0);
}

void mousePressed() {
  if (showCalendar) {
    handleCalendarClick();
    return;
  }
  if (mouseX > 30 && mouseX < 220 && mouseY > 40 && mouseY < 110) {
    activeBox = 1;
  }
  else if (mouseX > 220 && mouseX < 410 && mouseY > 40 && mouseY < 110) {
    activeBox = 2;
  }
  else if (mouseX > 410 && mouseX < 620 && mouseY > 40 && mouseY < 110) {
    activeBox = 0;
    calendarTargetBox = 3;
    showCalendar = true;
  }
  else if (mouseX > 620 && mouseX < 830 && mouseY > 40 && mouseY < 110) {
    activeBox = 0;
    calendarTargetBox = 4;
    showCalendar = true;
  }
  else if (mouseX > 870 && mouseX < 1020 && mouseY > 40 && mouseY < 110) {
    scrollOffset = 0;
    if (isDateOrderValid()) {
      performSearch();
      showResults = true;
    } else {
      println("End date must be after start date.");
    }
    activeBox = 0;
  }
  else if (mouseX > 1035 && mouseX < 1175 && mouseY > 40 && mouseY < 110) {
    useIATAMode = !useIATAMode;
    activeBox = 0;
  }
  else if (showResults && mouseX > 880 && mouseX < 1170 && mouseY > 170 && mouseY < 760) {
    for (int i=0;i<searchResults.size();i++){
      float yPos=170+(i*82)+scrollOffset;
      if (mouseX>880&&mouseX<1170&&mouseY>yPos&&mouseY<yPos+72){
        selectedFlight=searchResults.get(i);
        break;
      }
    }
    activeBox=0;
  }
  else {
    activeBox=0;
  }
}

void handleCalendarClick() {
  int startX = calendarX + 18;
  int startY = calendarY + 60;
  int cellW = 56;
  int cellH = 34;
  int offset = 6;

  for (int day = 1; day <= 31; day++) {
    int index = offset + day - 1;
    int col = index % 7;
    int row = index / 7;

    int x = startX + col * cellW;
    int y = startY + 18 + row * cellH;
    int w = cellW - 4;
    int h = cellH - 4;

    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      String chosenDate = formatJan2022Date(day);

      if (calendarTargetBox == 3) {
        startDateInput = chosenDate;
      } else if (calendarTargetBox == 4) {
        endDateInput = chosenDate;
      }

      showCalendar = false;
      return;
    }
  }

  if (mouseX < calendarX || mouseX > calendarX + calendarW ||
      mouseY < calendarY || mouseY > calendarY + calendarH) {
    showCalendar = false;
  }
}

void keyPressed() {
  if (showCalendar) return;

  if (activeBox == 1) {
    if (key == BACKSPACE && fromInput.length() > 0) {
      fromInput = fromInput.substring(0, fromInput.length() - 1);
    } else if (key != CODED && key != ENTER && key != RETURN) {
      fromInput += key;
    }
  } 
  else if (activeBox == 2) {
    if (key == BACKSPACE && toInput.length() > 0) {
      toInput = toInput.substring(0, toInput.length() - 1);
    } else if (key != CODED && key != ENTER && key != RETURN) {
      toInput += key;
    }
  }

  if (key == ENTER || key == RETURN) {
    scrollOffset = 0;
    if (isDateOrderValid()) {
      performSearch();
      showResults = true;
    } else {
      println("End date must be after start date.");
    }
  }
}

void performSearch() {
  searchResults.clear();

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

    boolean mD = isDateInRange(f.date, startDateInput, endDateInput);

    if (mF && mT && mD && !(fromInput.trim().equals("") && toInput.trim().equals("") && startDateInput.equals("") && endDateInput.equals(""))) {
      searchResults.add(f);
    }
  }

  if (searchResults.size() > 0) {
    selectedFlight = searchResults.get(0);
  } else {
    selectedFlight = null;
  }
}

String normalizeCity(String s) {
  if (s == null) return "";
  s = s.trim();
  int commaIndex = s.indexOf(",");
  if (commaIndex != -1) {
    s = s.substring(0, commaIndex);
  }
  return s.trim().toUpperCase();
}

boolean isDateInRange(String flightDateStr, String startStr, String endStr) {
  try {
    Date flightDate = flightFormat.parse(flightDateStr);

    if (!startStr.equals("")) {
      Date startDate = selectedDateFormat.parse(startStr);
      if (flightDate.before(startDate)) return false;
    }

    if (!endStr.equals("")) {
      Date endDate = selectedDateFormat.parse(endStr);
      endDate = new Date(endDate.getTime() + 24L * 60L * 60L * 1000L - 1);
      if (flightDate.after(endDate)) return false;
    }

    return true;
  } 
  catch (Exception e) {
    println("Date parse error: " + e.getMessage());
    return false;
  }
}

boolean isDateOrderValid() {
  try {
    if (startDateInput.equals("") || endDateInput.equals("")) return true;

    Date startDate = selectedDateFormat.parse(startDateInput);
    Date endDate = selectedDateFormat.parse(endDateInput);

    return !startDate.after(endDate);
  } 
  catch (Exception e) {
    return false;
  }
}

String formatJan2022Date(int day) {
  return "01/" + nf(day, 2) + "/2022";
}

class Flight {
  String date, airline, origin, dest;
  String originCity, destCity;

  Flight(String line) {
    String[] cols = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
    if (cols.length >= 9) {
      this.date = cols[0].trim();
      this.airline = cols[1].trim();
      this.origin = cols[3].replaceAll("\"", "").trim();
      this.originCity = cols[4].replaceAll("\"", "").trim();
      this.dest = cols[7].replaceAll("\"", "").trim();
      this.destCity = cols[8].replaceAll("\"", "").trim();
    }
  }
}
