/*
CHANGELOG:
T. Byrne, Benchmarks ReadCSV loading across all flight CSV files for testing, 07:50, 19/03/2026
T. Byrne, Uses SortFlights and displays the first 20 of each sort, 08:50, 19/03/2026
T. Byrne, Adds busiest airports, 15:40, 19/03/2026
T. Byrne, Adds least reliable airports, 17:05, 19/03/2026
T. Byrne, Moves from using OpenCSV to Kryo, improving the speed it takes to load the database in memory, 15:50, 24/03/2026
T. Byrne, Ports FSS to use the Kryo system. In this process, main was renamed to FlightDataHelper, its proformance testing logic was removed, and was made into a class, 15:40, 25/03/2026

*/

class FlightDataHelper {

  String findDataDir() {
    if (new File(sketchPath("flight_tables")).exists())
      return sketchPath("flight_tables") + "/";
    if (new File(sketchPath("../flight_tables")).exists())
      return sketchPath("../flight_tables") + "/";
    println("Warning: could not find flight_tables directory");
    return sketchPath("flight_tables") + "/";
  }
}

int getLateMinutes(Flight f) {
  if (f.arrTime == null || f.arrTime.isEmpty() || f.crsArrTime == null || f.crsArrTime.isEmpty()) return 0;
  int actual = Integer.parseInt(f.arrTime.trim());
  int sched = Integer.parseInt(f.crsArrTime.trim());
  return ((actual / 100) * 60 + (actual % 100)) - ((sched / 100) * 60 + (sched % 100));
}

ArrayList<Airport> getAirports(List<Flight> flightList) {
  ArrayList<Airport> airports = new ArrayList<Airport>();
  for (Flight f : flightList) {
    String[] ap = {f.origin, f.dest};
    String[] cities = {f.originCity, f.destCity};
    for (int j = 0; j < ap.length; j++) {
      String a = ap[j];
      int position = -1;
      for (int i = 0; i < airports.size(); i++) {
        if (airports.get(i).aberviation.equals(a)) {
          position = i;
          airports.get(i).flightCount++;
          airports.get(i).cancelledOrDiverted += (Integer.parseInt(f.cancelled) + Integer.parseInt(f.diverted));
        }
      }
      if (position == -1) {
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
