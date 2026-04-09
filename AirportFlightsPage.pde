String airportInput = ""; // stores the user's typed airport code input
boolean activeBox2 = false;

void initAirportFlights(){

}

void drawAirportFlights(){
    background(10, 25, 45);

// draw the US map image if loaded
    if (american_Map != null)
    {
    image(american_Map, 20, 130, 830, 549.6);
    }
// if user has typed something, find the co-ordinates of the airport
    if (airportInput.length() > 0)
    {
    String code = airportInput.toUpperCase().trim();
    PVector pos = airportCoords.get(code);

// if position has been found, draw the marker
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

// if search has been done, display the results table
    if (showResults)
    {
    drawResultsPanel2();
    }


}
// if user clocks inside text box, activate it
void airportMousePressed(){
    if (mouseX > 190 && mouseX < 850 && mouseY > 40 && mouseY < 110)
    {
        activeBox2 = true;
    }
// if search button has been pressed, conduct a search
    else if (mouseX > 870 && mouseX <1020 && mouseY > 40 && mouseY < 110)
    {
        scrollOffset = 0;
        performSearch2();
        showResults = true;
    }
// if user clocks anywhere else, deactivate text box
    else
    {
        activeBox2 = false;
    }

}

void airportKeyPressed(){
    if (!activeBox2) return;    //ignore pressed keys if text box is inactive

    if (key == BACKSPACE && airportInput.length() > 0)    // delete last character if backspace is pressed
    {
      airportInput = airportInput.substring(0, airportInput.length() - 1);
    }

// conduct search if enter key pressed
    else if (key == ENTER)
    {
      scrollOffset = 0;
      performSearch2();
      showResults = true;
    }

// add to input string if any regular character is pressed
    else if (key != CODED)
    {
      airportInput += key;
    }
}

// scrolling down the results page
void airportsMouseWheel(MouseEvent event) {
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

void drawHeaderSearch2()
{
// draw search box
  fill(255);
  noStroke();
  rect(190, 40, 660, 70, 10);
  fill(100);
// draw sample text inside search box
  textSize(12);
  text("Airport Code (e.g. JFK)", 205, 60);
  fill(0);
// draw user's input inside search box
  textSize(18);
  text(airportInput + (activeBox2 ? "|" : ""), 205, 90);
// draw search button
  fill(0, 120, 255);
  noStroke();
  rect(870, 40, 150, 70, 10);
  fill(255);
  textAlign(CENTER, CENTER);
  text("SEARCH", 945, 75);
  textAlign(LEFT, BASELINE);
}
