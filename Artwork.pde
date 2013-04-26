public class Artwork {
 
  int objectID;
  int imageCount;
  int division;
  int classification;
  int totalPageViews;
  int totalUniquePageViews;
  int totalEdits;
  int imagePermission;
  int orderNumber;
  LocalDate dateFirstViewed;
  LocalDate dateLastViewed;
  boolean onView;
  boolean isFeatured;
  Multimap<LocalDate, Event> events;
  Map<LocalDate, Integer> eventsCounts;
  
  PVector location; 
   
  private color c;
  private float colorAlive = 255.0;
  private float colorDead = 48.0;
  private float colorNow = colorDead;
  private boolean isAlive = false;
  private float decayRate = 0.0;
  private int sizeMultiplier = 1;
  private int daysAlive = 0;
   
  public Artwork(String _data) {
    String bits[];    
    
    bits = split(_data, ",");
    
    objectID = int(bits[0]);
    totalPageViews = int(bits[1]);
    totalUniquePageViews = int(bits[2]);
    totalEdits = int(bits[3]);
    classification = int(bits[4]);
    imagePermission = int(bits[5]);
    imageCount = int(bits[6]);
    division = int(bits[7]);
    onView = boolean(bits[8]);
    isFeatured = boolean(bits[9]);
    if (bits[10].equals("NULL") == false) dateFirstViewed = new LocalDate(bits[10]);
    if (bits[11].equals("NULL") == false) dateLastViewed = new LocalDate(bits[11]); 
    orderNumber = int(bits[12]);   
    
    events = ArrayListMultimap.create();  
    eventsCounts = new HashMap<LocalDate, Integer>();  
  }
  
  public void addEvent(Event _e) {  
    events.put(_e.eventDate, _e);
    
    Integer eventsCount = 0;
    for (Event e: events.get(_e.eventDate)) {
      eventsCount += e.value;
    }
    eventsCounts.put(_e.eventDate, eventsCount);
  }
  
  public void render() {
    noStroke();
    fill(c);
    pushMatrix();
    translate(location.x, location.y);
    rect(0, 0, ARTWORK_SIZE, ARTWORK_SIZE);
    popMatrix();
  }
  
  public void renderByDate(LocalDate _d) {
    if (events.get(_d).size() > 0) {
      
      for (Event e: events.get(_d)) {

        
        if (e.type == 1) {      
          c = color(colorAlive, 0, 0);      
        } else if (e.type == 2) {
          c = color(0, colorAlive, 0);      
        } else if (e.type == 3) {
          c = color(0, 0, colorAlive);      
        } else if (e.type == 4) {
          c = color(colorAlive, colorAlive, 0);      
        } else if (e.type == 5) {
          c = color(colorAlive, colorAlive, colorAlive);      
        } else {
          //do something
        }
        
        fill(c);        
        noStroke();
        pushMatrix();        
        translate(location.x, location.y);
        ellipse(0, 0, ARTWORK_SIZE*2, ARTWORK_SIZE*2);        
        popMatrix();    
      }


      
    } else {
      c = color(colorNow, 0, 0);      
      this.render();
    }    
  }
  
  public int getEventsCountByDate(LocalDate _d) {
    if (eventsCounts.containsKey(_d)) {
      return eventsCounts.get(_d);
    } else {
      return 0;
    }
  }
  
  public void setLocation(PVector _l) {
    location = _l;
  }
}
