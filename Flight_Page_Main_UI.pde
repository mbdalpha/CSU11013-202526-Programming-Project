import java.util.HashMap;
import java.text.SimpleDateFormat;
import java.util.Date;

Boolean flightFinderPage = true;
Boolean statsPage = false;
Boolean airportFlightsPage = false;
Boolean flightSorterPage = false;

//Flight Finder variables

ArrayList<Flight> allFlights=new ArrayList<Flight>();
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

//Stats Page Variables

//array printed out on Page 1 from left to right for both 'busyAirportNames'
//and 'busyValues'. sort from largest to smallest from left to right for top 20
//busiest airports and their respective values.
String[] busyAirportNames = {"LAX", "LHR", "JFK", "CDG", "DXB", "LAX", "LHR", "JFK", "CDG", "DXB"};
int[] busyValues = {300, 800, 1200, 600, 1500, 300, 800, 1200, 600, 1500};

//array printed out on Page 2 from top to bottom for both 'leastReliableAirportNames'
//and 'NoOfFlightsCancelledOrDelayed'. Reading array from left to right shows the
//Least reliable to 10th least reliable airport.
String[] leastReliableAirportNames = {"LAX", "LHR", "JFK", "CDG", "DXB", "LAX", "LHR", "JFK", "CDG", "DXB"};
//number of flights cancelled or delayed, position of integer in array corresponds to index
//of airports in the String array
int[] NoOfFlightsCancelledOrDelayed = {232, 500, 1000, 10, 100, 232, 500, 1000, 10, 100};


int[] Ranking = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

int flightDataSize = 2000;  // value can be altered to match data size of CSV file

int step = flightDataSize / 10;
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

//Flights by Airport variables

//ArrayList<Flight> allFlights2 = new ArrayList<Flight>();
//HashMap<String, PVector> airportCoords2 = new HashMap<String, PVector>();

String airportInput = "";
boolean activeBox2 = false;
//boolean showResults2 = false;
//float scrollOffset2 = 0;
//float easing2 = 0.15;
//float targetOffset2 = 0;

//Flight selectedFlight2 = null;
//PImage american_Map2;
//HashMap<String, PImage> logos2 = new HashMap<String, PImage>();


//Flight Sorted variables


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
float dateWidgetY = 70;
float lateWidgetX = 300;
float lateWidgetY = 70;
float searchWidgetX = 900;
float searchWidgetY = 70;

float startX2 = 300;
float startY2 = 400;
float radius = 40;
float gap = 20;

float fromX = 280;
float fromY = 350;
float toX = 560;
float toY = 350;
float clearX = 580;
float clearY = 700;

Widget duration = new Widget(dateWidgetX, dateWidgetY, 
                              widgetW, widgetH, "Duration");
Widget lateness = new Widget(lateWidgetX, lateWidgetY, 
                              widgetW, widgetH, "Lateness");
Widget search = new Widget(searchWidgetX, searchWidgetY, 
                              widgetW, widgetH, "Search");
Widget clear = new Widget(clearX, clearY, 
                          widgetW / 2, widgetH / 2, "clear");

void setup() {
  size(1200,800);

  // Flight Finder Setup

  american_Map=loadImage("American Map.png");

  String[] airlineCodes={"AA","UA","DL","F9","AS","B6","G4","HA","NK","WN"};
  for (String code:airlineCodes){
    logos.put(code,loadImage(code +".png"));
  }

  loadAirportLocations();

  String[] lines=loadStrings("flights2k.csv");
  for (int i=1;i<lines.length;i++){
    if (lines[i].trim().length()>0){
      allFlights.add(new Flight(lines[i]));
    }
  }

  flightFormat.setLenient(false);
  selectedDateFormat.setLenient(false);
  
  
  // Stats Page Setup
  
    textFont(createFont("Arial", 12));
  flightCounts = new int [totalBars];
  xLabels = new String[totalBars];
  
  thePageCounter = new pageCounter();
    
  marks = new Marking(120, 660, 540, flightDataSize, step);
  
    for (int i = 0; i < totalAirports; i++) {
      int index = i % busyValues.length; 
      int xPos = startX + i * spacing1;
    
      theLocation[i] = new Location(busyValues[index], xPos, busyAirportNames[index]);
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

    loadCSVData("flights2k.csv");
    
    //Flight sorter setup
    
      for (int i = 0; i < 31; i++) {
    int date = i + 1;
    int index = i + 5; //5 offsets it so 1 starts on 6th column (Saturday)
    int col = index % 7; //7 being the total columns (days in a week)
    int row = index / 7;
    
    float x = startX2 + col * (radius + gap);
    float y = startY2 + row * (radius + gap);
    
    dates[i] = new DateWidget(x, y, radius, date);
  }
  
}

void draw(){
  background(10,25,45);
  
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
  
  else if (statsPage) {
    
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

  else if (airportFlightsPage) {
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
       
      drawHeaderSearch2();
    
      if (showResults) 
      {
        drawResultsPanel2();
      }
    
  }
    
  else if (flightSorterPage) {
    background(10, 25, 45);
    textSize(20);

    duration.draw();
    lateness.draw();
    search.draw();
    clear.draw();
    
    for (int i = 0; i < 31; i++) {
      dates[i].draw();
    }
    textAlign(LEFT);
    fill(255);
    text(from, fromX, fromY);
    text(too, toX, toY);
  }
  
}

void loadAirportLocations(){
  String[] lines=loadStrings("airports_location.csv");
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

void drawHeaderSearch(){
  fill(255);
  noStroke();
  rect(30,40,820,70,10);

  stroke(220);
  line(220,50,220,100);
  line(410,50,410,100);
  line(620,50,620,100);

  fill(100);
  textSize(12);

  if (useIATAMode){
    text("From (Origin)",50,60);
    text("To (Dest)",240,60);
  }else{
    text("From City",50,60);
    text("To City",240,60);
  }

  text("Start Date",430,60);
  text("End Date",640,60);

  fill(0);
  textSize(18);

  text(fromInput+(activeBox==1?"|":""),50,90);
  text(toInput+(activeBox==2?"|" : ""),240,90);

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

void drawHeaderSearch2() 
{
  fill(255);
  noStroke();
  rect(190, 40, 660, 70, 10);
  fill(100);
  textSize(12);
  text("Airport Code (e.g. JFK)", 205, 60);
  fill(0);
  textSize(18);
  text(airportInput + (activeBox2 ? "|" : ""), 205, 90);
  fill(0, 120, 255);
  noStroke();
  rect(870, 40, 150, 70, 10);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(16);
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
      text("AIRLINE: " + f2.airline, 1050, yPos + 45);

      PImage logoImg = logos.get(f2.airline);
      if (logoImg != null) 
      {
        image(logoImg, 1120, yPos + 12, 40, 40);
      } 
      else 
      {
        fill(255, 100);
        textSize(11);
        text(f2.airline, 1120, yPos + 35);
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
  text("MKT_CARRIER: " + f.airline, leftX, panelY + 55);
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

void mouseWheel(MouseEvent event) {
  if (!showResults || showCalendar) return;

  if (mouseX < resultsPanelX || mouseX > resultsPanelX + resultsPanelW ||
      mouseY < resultsPanelY || mouseY > resultsPanelY + resultsPanelH) {
    return;
  }

  float e = event.getCount();
  targetOffset -= e * 30;
  targetOffset = constrain(targetOffset, getMaxScroll(), 0);
}

void mousePressed() {
  
  if (flightFinderPage) {
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
  
  else if (statsPage) {
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
      }    
  }

  else if (airportFlightsPage) {
      if (mouseX > 190 && mouseX < 850 && mouseY > 40 && mouseY < 110) 
      {
        activeBox2 = true;
      }
      else if (mouseX > 870 && mouseX <1020 && mouseY > 40 && mouseY < 110) 
      {
        scrollOffset = 0;
        performSearch2();
        showResults = true;
      }
      else 
      {
        activeBox2 = false;
      }
  }
    
  else if (flightSorterPage) {
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
    if (mouseX > clear.x &&
        mouseX < clear.x + clear.w &&
        mouseY > clear.y &&
        mouseY < clear.y + clear.h) {
           fromSelected = false;
           toSelected = false;
           from = "From: ";
           too = "To: ";
        }
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
}

void mouseDragged() {
  if (draggingScrollbar) {
    updateScrollFromScrollbar(mouseY - scrollbarDragOffset);
  }
}

void mouseReleased() {
  draggingScrollbar = false;
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

void keyPressed() {
  
  //TEMPORARY SWITCHING BETWEEN SCREENS FUNCTION
  if (key == '1') {
    flightFinderPage = true;
    statsPage = false;
    airportFlightsPage = false;
    flightSorterPage = false;
  }
  if (key == '2') {
    flightFinderPage = false;
    statsPage = true;
    airportFlightsPage = false;
    flightSorterPage = false;  }
  if (key == '3') {
    flightFinderPage = false;
    statsPage = false;
    airportFlightsPage = true;
    flightSorterPage = false;  }
  if (key == '4') {
    flightFinderPage = false;
    statsPage = false;
    airportFlightsPage = false;
    flightSorterPage = true;  
  }
  
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
  
  if (airportFlightsPage) {
    if (!activeBox2) return;

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

class Flight {
  String flDate;
  String airline;
  String flightNum;
  String origin;
  String originCity;
  String originState;
  String originWac;
  String dest;
  String destCity;
  String destState;
  String destWac;
  String crsDepTime;
  String depTime;
  String crsArrTime;
  String arrTime;
  String cancelled;
  String diverted;
  String distance;

  Flight(String line) {
    String[] cols = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
    if (cols.length >= 18) {
      this.flDate = cols[0].replaceAll("\"", "").trim();
      this.airline = cols[1].replaceAll("\"", "").trim();
      this.flightNum = cols[2].replaceAll("\"", "").trim();
      this.origin = cols[3].replaceAll("\"", "").trim();
      this.originCity = cols[4].replaceAll("\"", "").trim();
      this.originState = cols[5].replaceAll("\"", "").trim();
      this.originWac = cols[6].replaceAll("\"", "").trim();
      this.dest = cols[7].replaceAll("\"", "").trim();
      this.destCity = cols[8].replaceAll("\"", "").trim();
      this.destState = cols[9].replaceAll("\"", "").trim();
      this.destWac = cols[10].replaceAll("\"", "").trim();
      this.crsDepTime = cols[11].replaceAll("\"", "").trim();
      this.depTime = cols[12].replaceAll("\"", "").trim();
      this.crsArrTime = cols[13].replaceAll("\"", "").trim();
      this.arrTime = cols[14].replaceAll("\"", "").trim();
      this.cancelled = cols[15].replaceAll("\"", "").trim();
      this.diverted = cols[16].replaceAll("\"", "").trim();
      this.distance = cols[17].replaceAll("\"", "").trim();
    }
  }
}

//STATS PAGE WORK

// Rians code to read CSV file, alter only if necessary

void loadCSVData(String filename) {
  Table table = loadTable(filename, "header");

  for (TableRow row : table.rows()) {
    if (row.getString("CANCELLED").trim().startsWith("1")) continue;
    if (row.getString("DIVERTED").trim().startsWith("1")) continue;

    String actualArrival    = row.getString("ARR_TIME").trim();
    String scheduledArrival = row.getString("CRS_ARR_TIME").trim();
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



// Neels code


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

  int maxVal = flightDataSize;
  for (int v : busyValues) {
    if (v > maxVal) maxVal = v;
  }

  stroke(100);
  line(leftPad, bottomY, leftPad + chartWidth, bottomY);
  line(leftPad, topPad, leftPad, bottomY);
  
  marks.draw();


  float barWidth = chartWidth / (float) totalAirports;
  
  for (int i = 0; i < totalAirports; i++) {
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


// Rians code for Flight Arrival Lateness - Frequency Chart

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
