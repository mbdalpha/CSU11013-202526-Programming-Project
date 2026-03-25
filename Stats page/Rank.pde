public class Rank {

  int ranking;
  int yPos;
  String name;
  
  public Rank(int x, int pos, String airportName) {   
    ranking = x;
    yPos = pos;
    name = airportName;
  }
  
  void draw() {
  
        if (ranking < 10) {
        textSize(20);
        fill(100);
        text(ranking + ". " + name, 600, yPos); 
        }
        
        if (ranking == 10) {
        textSize(20);
        fill(100);
        text(ranking + ". " + name, 590, yPos); 
        }
  
  
  }



}
