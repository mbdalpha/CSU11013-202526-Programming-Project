//Flight Finder variables

ArrayList<Flight> searchResults=new ArrayList<Flight>();
HashMap<String, PVector> airportCoords=new HashMap<String, PVector>();

String fromInput="";
String toInput="";
String startDateInput="";
String endDateInput="";

int activeBox=0;
boolean showResults=false;
float scrollOffset=0,targetOffset=0,easing=0.15;

Flight selectedFlight=null;
PImage american_Map;
HashMap<String, PImage>logos=new HashMap<String, PImage>();

boolean showCalendar=false;
int calendarTargetBox=0;   // 3=start date, 4=end date
int calendarX=390;
int calendarY=140;
int calendarW=430;
int calendarH=295;

boolean useIATAMode=true;

boolean draggingScrollbar=false;
float scrollbarDragOffset=0;

int resultsPanelX=870;
int resultsPanelY=130;
int resultsPanelW=310;
int resultsPanelH=640;

int resultsClipX=870;
int resultsClipY=170;
int resultsClipW=310;
int resultsClipH=580;

int resultCardX=880;
int resultCardW=290;
int resultCardH=72;
int resultStepY=82;

int scrollbarX=1172;
int scrollbarY=170;
int scrollbarW=6;
int scrollbarH=580;

SimpleDateFormat flightFormat=new SimpleDateFormat("MM/dd/yyyy HH:mm");
SimpleDateFormat selectedDateFormat=new SimpleDateFormat("MM/dd/yyyy");

void initFlightFinder(){
  american_Map=loadImage("map/American Map.png");

  String[] airlineCodes={"AA","UA","DL","F9","AS","B6","G4","HA","NK","WN"};
  for (String code:airlineCodes){
    logos.put(code,loadImage("airlines/" + code +".png"));
  }

  loadAirportLocations();

  flightFormat.setLenient(false);
  selectedDateFormat.setLenient(false);
}

void drawFlightFinder(){
  if (flightFinderPage) {

    if (american_Map!=null){
      image(american_Map,20,130,830,549.6);
    }
    if (selectedFlight!=null){
      drawConnection(selectedFlight);
    }
  
    float dx=targetOffset-scrollOffset;
    scrollOffset+=dx*easing;
  
    drawHeaderSearch();
  
    if (showResults){
      drawResultsPanel();
    }
    if (selectedFlight!=null){
      drawFlightDetailsPanel(selectedFlight);
    }
    if (showCalendar){
      drawCalendarPopup();
    } 
  }
}

void finderMousePressed(){
  if (showCalendar) {
    handleCalendarClick();
    return;
  }

  if (mouseX > 190 && mouseX < 355 && mouseY > 40 && mouseY < 110) {
    activeBox = 1;
  }
  else if (mouseX > 355 && mouseX < 520 && mouseY > 40 && mouseY < 110) {
    activeBox = 2;
  }
  else if (mouseX > 520 && mouseX < 685 && mouseY > 40 && mouseY < 110) {
    activeBox = 0;
    calendarTargetBox = 3;
    showCalendar = true;
  }
  else if (mouseX > 685 && mouseX < 840 && mouseY > 40 && mouseY < 110) {
    activeBox = 0;
    calendarTargetBox = 4;
    showCalendar = true;
  }
  else if (mouseX > 870 && mouseX < 1020 && mouseY > 40 && mouseY < 110) {
    scrollOffset = 0;
    targetOffset = 0;
    draggingScrollbar = false;

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
  else if (isMouseOnScrollbarTrack()) {
    if (getMaxScroll() < 0) {
      if (isMouseOnScrollbarThumb()) {
        draggingScrollbar = true;
        scrollbarDragOffset = mouseY - getScrollbarThumbY();
      } else {
        draggingScrollbar = true;
        scrollbarDragOffset = getScrollbarThumbHeight() / 2.0;
        updateScrollFromScrollbar(mouseY - scrollbarDragOffset);
      }
    }
    activeBox = 0;
  }
  else if (showResults && mouseX > 880 && mouseX < 1170 && mouseY > 170 && mouseY < 760) {
    for (int i = 0; i < searchResults.size(); i++) {
      float yPos = 170 + (i * resultStepY) + scrollOffset;
      if (mouseX > 880 && mouseX < 1170 && mouseY > yPos && mouseY < yPos + resultCardH) {
        selectedFlight = searchResults.get(i);
        break;
      }
    }
    activeBox = 0;
  }
  else {
    activeBox = 0;
  }
}

void finderMouseDragged() {
  if (draggingScrollbar) {
    updateScrollFromScrollbar(mouseY - scrollbarDragOffset);
  }
}

void finderMouseReleased() {
  draggingScrollbar = false;
}

void finderKeyPressed(){
  if (showCalendar) return;

  if (activeBox == 1) {
    fromInput = updateTextInput(fromInput);
  }
  else if (activeBox == 2) {
    toInput = updateTextInput(toInput);
  }

  if (key == ENTER || key == RETURN) {
    scrollOffset = 0;
    targetOffset = 0;
    draggingScrollbar = false;

    if (isDateOrderValid()) {
      performSearch();
      showResults = true;
    } else {
      println("End date must be after start date.");
    }
  }
}

void drawHeaderSearch(){
  fill(255);
  noStroke();
  rect(190,40,660,70,10);

  stroke(220);
  line(355,50,355,100);
  line(520,50,520,100);
  line(685,50,685,100);

  fill(100);
  textSize(12);

  if (useIATAMode){
    text("From (Origin)",205,60);
    text("To (Dest)",370,60);
  }else{
    text("From City",205,60);
    text("To City",370,60);
  }

  text("Start Date",535,60);
  text("End Date",700,60);

  fill(0);
  textSize(18);

  text(fromInput+(activeBox==1?"|":""),205,90);
  text(toInput+(activeBox==2?"|" : ""),370,90);

  if (startDateInput.equals("")) {
    fill(140);
    text("Select date", 535, 90);
  } else {
    fill(0);
    text(startDateInput, 535, 90);
  }

  if (endDateInput.equals("")) {
    fill(140);
    text("Select date", 700, 90);
  } else {
    fill(0);
    text(endDateInput, 700, 90);
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
  rect(resultsPanelX, resultsPanelY, resultsPanelW, resultsPanelH, 10);

  fill(255);
  textSize(16);
  text("Results: " + searchResults.size(), 880, 160);

  push();
  clip(resultsClipX, resultsClipY, resultsClipW, resultsClipH);

  for (int i = 0; i < searchResults.size(); i++) {
    float yPos = resultsClipY + (i * resultStepY) + scrollOffset;

    if (yPos > 100 && yPos < 780) {
      Flight f = searchResults.get(i);

      fill(255, 40);
      noStroke();
      rect(resultCardX, yPos, resultCardW, resultCardH, 8);

      fill(255);
      textSize(13);
      text(f.origin + " → " + f.dest, 895, yPos + 20);

      textSize(10);
      fill(200);
      text(f.originCity + " → " + f.destCity, 895, yPos + 38);
      text("DATE: " + f.flDate, 895, yPos + 53);
      text("AIRLINE: " + f.carrier, 895, yPos + 67);

      PImage logoImg = logos.get(f.carrier);
      if (logoImg != null) {
        image(logoImg, 1120, yPos + 16, 34, 34);
      } else {
        fill(255, 120);
        text(f.carrier, 1120, yPos + 38);
      }
    }
  }

  noClip();
  pop();

  drawScrollbar();
}

void drawResultsPanel2() {
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
      Flight f2 = searchResults.get(i);

      fill(255, 40);
      noStroke();
      rect(880, yPos, 290, 65, 8);

      fill(255);
      textSize(13);
      text(f2.origin + " → " + f2.dest, 895, yPos + 25);

      fill(200);
      textSize(11);
      text("DATE: " + f2.flDate, 895, yPos + 45);
      text("AIRLINE: " + f2.carrier, 1050, yPos + 45);

      PImage logoImg = logos.get(f2.carrier);
      if (logoImg != null) 
      {
        image(logoImg, 1120, yPos + 12, 40, 40);
      } 
      else 
      {
        fill(255, 100);
        textSize(11);
        text(f2.carrier, 1120, yPos + 35);
      }
    }
  }

  noClip();
  pop();
}

void drawScrollbar() {
  noStroke();

  fill(255, 35);
  rect(scrollbarX, scrollbarY, scrollbarW, scrollbarH, 4);

  float thumbH = getScrollbarThumbHeight();
  float thumbY = getScrollbarThumbY();

  if (getMaxScroll() == 0) {
    fill(255, 70);
  } else if (draggingScrollbar) {
    fill(255, 180);
  } else {
    fill(255, 130);
  }

  rect(scrollbarX, thumbY, scrollbarW, thumbH, 4);
}

void drawFlightDetailsPanel(Flight f) {
  int panelX = 20;
  int panelY = 680;  
  int panelW = 830;
  int panelH = 90;   

  fill(255, 28);
  noStroke();
  rect(panelX, panelY, panelW, panelH, 10);

  fill(255);
  textSize(14);
  text("Selected Flight Details", panelX + 15, panelY + 20);

  textSize(10);
  fill(220);

  int leftX = panelX + 15;
  int rightX = panelX + 430;

  text("FL_DATE: " + f.flDate, leftX, panelY + 40);
  text("MKT_CARRIER: " + f.carrier, leftX, panelY + 55);
  text("MKT_CARRIER_FL_NUM: " + f.flightNum, leftX, panelY + 70);

  text("ORIGIN: " + f.origin, rightX, panelY + 40);
  text("ORIGIN_CITY_NAME: " + f.originCity, rightX, panelY + 55);
  text("ORIGIN_STATE_ABR: " + f.originState, rightX, panelY + 70);

  text("ORIGIN_WAC: " + f.originWac, leftX + 180, panelY + 40);
  text("DEST: " + f.dest, leftX + 180, panelY + 55);
  text("DEST_CITY_NAME: " + f.destCity, leftX + 180, panelY + 70);

  text("DEST_STATE_ABR: " + f.destState, rightX + 210, panelY + 40);
  text("DEST_WAC: " + f.destWac, rightX + 210, panelY + 55);
  text("DISTANCE: " + f.distance, rightX + 210, panelY + 70);

  fill(255, 210, 120);
  text("CRS_DEP_TIME: " + f.crsDepTime + "   DEP_TIME: " + f.depTime, panelX + 15, panelY + 86);
  text("CRS_ARR_TIME: " + f.crsArrTime + "   ARR_TIME: " + f.arrTime, panelX + 340, panelY + 86);
  text("CANCELLED: " + f.cancelled + "   DIVERTED: " + f.diverted, panelX + 620, panelY + 86);
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
        if (startDateInput.equals(chosenDate)) {
          startDateInput = "";
        } else {
          startDateInput = chosenDate;
        }
      } else if (calendarTargetBox == 4) {
        if (endDateInput.equals(chosenDate)) {
          endDateInput = "";
        } else {
          endDateInput = chosenDate;
        }
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

    boolean mD = isDateInRange(f.flDate, startDateInput, endDateInput);

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

void performSearch2() {
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
    Date flightDate = selectedDateFormat.parse(flightDateStr);

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


float getTotalContentHeight() {
  return searchResults.size() * resultStepY;
}

float getMaxScroll() {
  float maxScroll = -(getTotalContentHeight() - resultsClipH);
  if (maxScroll > 0) maxScroll = 0;
  return maxScroll;
}

float getScrollbarThumbHeight() {
  float totalContentHeight = max(getTotalContentHeight(), (float)resultsClipH);
  float thumbH = (resultsClipH * resultsClipH) / totalContentHeight;
  return constrain(thumbH, 40, resultsClipH);
}

float getScrollbarThumbY() {
  float maxScroll = getMaxScroll();
  float thumbH = getScrollbarThumbHeight();

  if (maxScroll == 0) return scrollbarY;

  float progress = scrollOffset / maxScroll;
  progress = constrain(progress, 0, 1);

  return scrollbarY + progress * (scrollbarH - thumbH);
}

boolean isMouseOnScrollbarTrack() {
  return showResults &&
         mouseX >= scrollbarX - 3 &&
         mouseX <= scrollbarX + scrollbarW + 3 &&
         mouseY >= scrollbarY &&
         mouseY <= scrollbarY + scrollbarH;
}

boolean isMouseOnScrollbarThumb() {
  float thumbY = getScrollbarThumbY();
  float thumbH = getScrollbarThumbHeight();

  return isMouseOnScrollbarTrack() &&
         mouseY >= thumbY &&
         mouseY <= thumbY + thumbH;
}

void updateScrollFromScrollbar(float newThumbTop) {
  float maxScroll = getMaxScroll();

  if (maxScroll == 0) {
    scrollOffset = 0;
    targetOffset = 0;
    return;
  }

  float thumbH = getScrollbarThumbHeight();
  float constrainedThumbTop = constrain(newThumbTop, scrollbarY, scrollbarY + scrollbarH - thumbH);
  float progress = (constrainedThumbTop - scrollbarY) / (scrollbarH - thumbH);

  targetOffset = progress * maxScroll;
  scrollOffset = targetOffset;
}

String updateTextInput(String currentValue) {
  if ((key == BACKSPACE || key == DELETE) && currentValue.length() > 0) {
    return currentValue.substring(0, currentValue.length() - 1);
  } else if (isPrintableKey(key)) {
    return currentValue + key;
  }
  return currentValue;
}

boolean isPrintableKey(char k) {
  return k != CODED && k >= 32 && k != 127;
}

void finderMouseWheel(MouseEvent event) {
  if (!showResults || showCalendar) return;

  if (mouseX < resultsPanelX || mouseX > resultsPanelX + resultsPanelW ||
      mouseY < resultsPanelY || mouseY > resultsPanelY + resultsPanelH) {
    return;
  }

  float e = event.getCount();
  targetOffset -= e * 30;
  targetOffset = constrain(targetOffset, getMaxScroll(), 0);
}

void loadAirportLocations(){
  String[] lines=loadStrings("airport_tables/airports_location.csv");
  for (int i=1; i<lines.length;i++){
    String[] cols=lines[i].split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
    if (cols.length>17){
      String code=cols[0].replaceAll("\"","").trim();
      float x=float(cols[17].trim());
      float y=float(cols[10].trim());
      airportCoords.put(code,new PVector(x,y));
    }
  }
}
