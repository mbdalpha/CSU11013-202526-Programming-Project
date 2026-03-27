public class Rank {

  int ranking;
  int yPos;
  
  public Rank(int x, int pos) {   
    ranking = x;
    yPos = pos;
  }
  
  void draw() {
  
        textSize(20);
        fill(0);

        if (ranking == 1) {
                text(ranking + "st", 300, yPos); 
        }
        else if (ranking == 2) {
                text(ranking + "nd", 300, yPos); 
        }
        else if (ranking == 3) {
                text(ranking + "rd", 300, yPos); 
        }
        else if (ranking == 10) {
                text(ranking + "th", 300, yPos); 
        }
        else {
                text(ranking + "th", 300, yPos); 
        }
        
  }
}
