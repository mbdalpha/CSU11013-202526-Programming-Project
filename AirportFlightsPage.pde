
String airportInput = "";
boolean activeBox2 = false;

void initAirportFlights(){

}

void drawAirportFlights(){
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

void airportMousePressed(){
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

void airportKeyPressed(){
    if (!activeBox2) return;

    if (key == BACKSPACE && airportInput.length() > 0)
    {
      airportInput = airportInput.substring(0, airportInput.length() - 1);
    }
    else if (key == ENTER)
    {
      scrollOffset = 0;
      performSearch2();
      showResults = true;
    }
    else if (key != CODED)
    {
      airportInput += key;
    }
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
