/*
CHANGELOG:
T. Byrne, Benchmarks ReadCSV loading across all flight CSV files for testing, 07:50, 19/03/2026
T. Byrne, Uses SortFlights and displays the first 20 of each sort, 08:50, 19/03/2026
T. Byrne, Adds busiest airports, 15:40, 19/03/2026
T. Byrne, Adds least reliable airports, 17:05, 19/03/2026

*/

final String[] DATA_FILES = {"flights2k.csv", "flights10k.csv", "flights100k.csv", "flights_full.csv"};

void setup() {
  size(200, 200);
  String dataDir = findDataDir();

  println("=== CSV Loading Performance Test ===\n");
  println(String.format("%-20s %10s %12s", "File", "Rows", "Time (ms)"));
  println("----------------------------------------------");

  for (String file : DATA_FILES) {
    String path = dataDir + file;
    if (!new File(path).exists()) {
      println(String.format("%-20s %10s %12s", file, "-", "NOT FOUND"));
      continue;
    }

    long start = System.nanoTime();
    ReadCSV csv = new ReadCSV(path);
    long elapsed = (System.nanoTime() - start) / 1_000_000;

    println(String.format("%-20s %,10d %,10d ms", file, csv.getFlights().size(), elapsed));
  }

  // sort and print using first available file
  String firstPath = null;
  for (String file : DATA_FILES) {
    String path = dataDir + file;
    if (new File(path).exists()) {
      firstPath = path;
      break;
    }
  }
  //firstPath = dataDir + DATA_FILES[3]; // makes it use the largest for sorting, for testing mainly

  if (firstPath != null) {
    ReadCSV csv = new ReadCSV(firstPath);
    SortFlights sorter = new SortFlights();

    List<Flight> flights = csv.getFlights();
    int n = min(20, flights.size());

    println("\n=== Top 20 Most Late (Descending) ===");
    println(String.format("%-12s %-6s %-6s %-8s %-8s %s", "Date", "From", "To", "Sched", "Actual", "Late(min)"));
    for (Flight f : sorter.latenessSort(flights, SortFlights.DESCENDING).subList(0, n)) {
      int late = getLateMinutes(f);
      println(String.format("%-12s %-6s %-6s %-8s %-8s %d", f.flDate, f.origin, f.dest, f.crsArrTime, f.arrTime, late));
    }

    println("\n=== Top 20 by Date (Ascending) ===");
    println(String.format("%-12s %-6s %-6s %-10s %s", "Date", "From", "To", "Carrier", "Flight#"));
    for (Flight f : sorter.dateSort(flights, SortFlights.ASCENDING).subList(0, n)) {
      println(String.format("%-12s %-6s %-6s %-10s %s", f.flDate, f.origin, f.dest, f.carrier, f.flightNum));
    }

    println("\n=== Top 20 by Origin Code (Ascending) ===");
    println(String.format("%-6s %-20s %-6s %-20s %s", "From", "City", "To", "City", "Date"));
    for (Flight f : sorter.sortByOriginCode(flights, SortFlights.ASCENDING).subList(0, n)) {
      println(String.format("%-6s %-20s %-6s %-20s %s", f.origin, f.originCity, f.dest, f.destCity, f.flDate));
    }

    println("\n=== Top 20 by Destination Code (Ascending) ===");
    println(String.format("%-6s %-20s %-6s %-20s %s", "To", "City", "From", "City", "Date"));
    for (Flight f : sorter.sortByDestCode(flights, SortFlights.ASCENDING).subList(0, n)) {
      println(String.format("%-6s %-20s %-6s %-20s %s", f.dest, f.destCity, f.origin, f.originCity, f.flDate));
    }

    println("\n=== Top 20 by Origin City (Ascending) ===");
    println(String.format("%-20s %-6s %-20s %-6s %s", "Origin City", "Code", "Dest City", "Code", "Date"));
    for (Flight f : sorter.sortByOriginCity(flights, SortFlights.ASCENDING).subList(0, n)) {
      println(String.format("%-20s %-6s %-20s %-6s %s", f.originCity, f.origin, f.destCity, f.dest, f.flDate));
    }

    println("\n=== Top 20 by Destination City (Ascending) ===");
    println(String.format("%-20s %-6s %-20s %-6s %s", "Dest City", "Code", "Origin City", "Code", "Date"));
    for (Flight f : sorter.sortByDestCity(flights, SortFlights.ASCENDING).subList(0, n)) {
      println(String.format("%-20s %-6s %-20s %-6s %s", f.destCity, f.dest, f.originCity, f.origin, f.flDate));
    }

    List<Airport> busiest = sorter.sortByBusiest(flights, SortFlights.DESCENDING);
    int airportCount = min(20, busiest.size());
    println("\n=== Top 20 Busiest Airports (Descending) ===");
    println(String.format("%-6s %-20s %s", "Code", "City", "Flights"));
    for (Airport ap : busiest.subList(0, airportCount)) {
      println(String.format("%-6s %-20s %d", ap.aberviation, ap.city, ap.flightCount));
    }
    List<Airport> leastReliable = sorter.sortByReliability(flights, SortFlights.DESCENDING);
    int airportCount1 = min(20, leastReliable.size());
    println("\n=== Top 20 Least Reliable Airports (Descending) ===");
    println(String.format("%-6s %-20s %s", "Code", "City", "Cancellations or Diversions"));
    for (Airport ap : leastReliable.subList(0, airportCount1)) {
      println(String.format("%-6s %-20s %d", ap.aberviation, ap.city, ap.cancelledOrDiverted));
    }
  }

  println("\nDone.");
  exit();
}

String findDataDir() {
  if (new File(sketchPath("flight_tables")).exists())
    return sketchPath("flight_tables") + "/";
  if (new File(sketchPath("../flight_tables")).exists())
    return sketchPath("../flight_tables") + "/";
  println("Warning: could not find flight_tables directory");
  return sketchPath("flight_tables") + "/";
}

int getLateMinutes(Flight f) {
  if (f.arrTime == null || f.arrTime.isEmpty() || f.crsArrTime == null || f.crsArrTime.isEmpty()) return 0;
  int actual = Integer.parseInt(f.arrTime.trim());
  int sched = Integer.parseInt(f.crsArrTime.trim());
  return ((actual / 100) * 60 + (actual % 100)) - ((sched / 100) * 60 + (sched % 100));
}

ArrayList<Airport> getAirports(List<Flight> flightList){
  ArrayList<Airport> airports = new ArrayList<Airport>();
  for (Flight f : flightList) {
    String[] ap = {f.origin, f.dest};
    String[] cities = {f.originCity, f.destCity};
    for(int j = 0; j < ap.length; j++){
      String a = ap[j];
      int position = -1;
      for(int i = 0; i < airports.size(); i++){
        if(airports.get(i).aberviation.equals(a)){
          position = i;
          airports.get(i).flightCount++;
          airports.get(i).cancelledOrDiverted += (Integer.parseInt(f.cancelled) + Integer.parseInt(f.diverted));
        }
      }
      if(position == -1){
        Airport newAirport = new Airport();
        newAirport.aberviation = a;
        newAirport.city = cities[j];
        newAirport.flightCount = 1;
        newAirport.cancelledOrDiverted = (Integer.parseInt(f.cancelled) + Integer.parseInt(f.diverted));
        airports.add(newAirport);
      }
    }
  }
  return airports;
}

void draw() {
}
