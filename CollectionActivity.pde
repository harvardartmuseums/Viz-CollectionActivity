//Info on creating date ranges: http://stackoverflow.com/questions/2689379/how-to-get-a-list-of-dates-between-two-dates-in-java

final static int ARTWORK_SIZE = 1;
final static int ARTWORK_SPACING = 1;

PFont fontA;
List<LocalDate> dates = new ArrayList<LocalDate>();
Map<Integer, Artwork> artworks = new LinkedHashMap<Integer, Artwork>();
int i = 0;
boolean paused = false;
boolean recording = false;

void setup() {
  size(1280, 720);

  //Load data about the artworks  
  fillArtwork(artworks);
  
  arrangeArtworks();
  
  //Create a list of dates for the time series
  LocalDate startDate = new LocalDate("2009-05-18");
  LocalDate endDate = new LocalDate("2013-02-20");

  int days = Days.daysBetween(startDate, endDate).getDays() + 1; //adding one ensures the endDate is included in the list of days to render
  for (int i=0; i < days; i++) {
      LocalDate d = startDate.withFieldAdded(DurationFieldType.days(), i);
      dates.add(d);
  }

  //Prepare the remaining odds and ends
  fontA = loadFont("CourierNew36.vlw");
  textFont(fontA, 15);
}

void draw() {
  background(0);
  
  LocalDate currentDate = dates.get(i);

  int totalEventsCount = 0;
  int totalObjectsWithEvents = 0;
  int eventCount = 0;
  
  for (Artwork a: artworks.values()) {
    a.renderByDate(currentDate);
    
    eventCount = a.getEventsCountByDate(currentDate);
    if (eventCount > 0) {
      totalEventsCount += eventCount;
      totalObjectsWithEvents++;
    }
  }
  
  //Render the information panel
  fill(255);
  text(dates.get(i).toString("yyyy-MM-dd") + " (" + dates.get(i).dayOfWeek().getAsText() + ")", 8, height-6);    
  text(totalEventsCount + " events, " + totalObjectsWithEvents + " objects affected", 900, height-6);      
  
  //Save the frames for output to a video file
  if (recording) {
    saveFrame("output/frames####.png");  
  }
  
  if (!paused) {
    i++;
    if (i >= dates.size()) exit();
  }
}

void arrangeArtworks() {
  //Arrange the artworks
  int y = 0;
  int x = 0;

  for (Artwork a: artworks.values()) {
    a.setLocation(new PVector(x, y));
    
    x = x + ARTWORK_SIZE + ARTWORK_SPACING;
    if (x >= width) {
      x = 0;
      y = y + ARTWORK_SIZE + ARTWORK_SPACING;
    }
  }
      
  
}


