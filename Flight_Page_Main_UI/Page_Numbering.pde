class pageCounter {
  float margin = 20; 
  
  void display(int current, int total) {
    pushStyle(); 
    
    fill(255); 
    textSize(18);
    textAlign(RIGHT, BOTTOM);
    
    String label = "Page " + current + " of " + total;
    
    text(label, width - margin, height - margin);
    
    popStyle(); 
  }
}
