class Rank {

  int ranking;
  int yPos;
  
  public Rank(int x, int pos) {   
    ranking = x;
    yPos = pos;
  }
  
  void draw() {
  
        textSize(20);
        fill(0);

        switch(ranking) {
            case 1:
                text(ranking + "st", 300, yPos);
                break;
            case 2:
                text(ranking + "nd", 300, yPos);
                break;
            case 3:
                text(ranking + "rd", 300, yPos);
                break;
            case 10:
                text(ranking + "th", 300, yPos);
                break;
            default:
                text(ranking + "th", 300, yPos);
                break;
        }
        
  }
}
