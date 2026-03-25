public class Airport {

    int rectWidth = 30;
    int rectHeight;
    int xPos;
    String name;

    public Airport(int x, int pos, String airportName) {
        rectHeight = x;
        xPos = pos;
        name = airportName;
    }
    
    void draw() {
      fill(100);
      float scaledHeight = map(rectHeight, 0, flightDataSize, 0, 300);
      rect(xPos, 450 - scaledHeight, rectWidth, scaledHeight);   
      
      
        textSize(15);
        text(name, xPos + 2, 475); 
    }
}
