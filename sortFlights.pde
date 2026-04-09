/*
CHANGELOG:
T. Byrne, Sorts flight lists by lateness, date, and airport, 08:50, 19/03/2026
T. Byrne, Adds sorting by busyness for airports, 15:40, 19/03/2026
T. Byrne, Refactors code to reduce repetition, 15:50, 19/03/2026
T. Byrne, Adds least reliable airports, 17:05, 19/03/2026
T. Byrne, Adds date range search function, 11:00, 26/03/2026
T. Byrne, Adds blueprint for airport search function (currently unfuctional), 17:00, 26/03/2026
T. Byrne, Finishes airport search function, using simpiler approach, 15:40, 27/03/2026
T. Byrne, fixes statistics pages not loading properly, 11:00, 08/04/2026
T. Byrne, adds sortByDuration, 16:30, 09/04/2026

*/

import java.util.Collections;
import java.util.Comparator;
import java.util.ArrayList;

class SortFlights {
  public static final boolean ASCENDING = true;
  public static final boolean DESCENDING = false;

  private List<Flight> sortBy(List<Flight> flightList, boolean ascending, Comparator<Flight> comp) {
    final int dir = ascending ? 1 : -1;
    List<Flight> sorted = new ArrayList<Flight>(flightList);
    Collections.sort(sorted, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) {
        return dir * comp.compare(a, b);
      }
    });
    return sorted;
  }

  public List<Flight> latenessSort(List<Flight> flightList, boolean ascending) {
    return sortBy(flightList, ascending, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) { return getLateness(a) - getLateness(b); }
    });
  }

  public List<Flight> dateSort(List<Flight> flightList, boolean ascending) {
    return sortBy(flightList, ascending, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) { return a.flDate.compareTo(b.flDate); }
    });
  }

  public List<Flight> sortByOriginCode(List<Flight> flightList, boolean ascending) {
    return sortBy(flightList, ascending, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) { return a.origin.compareTo(b.origin); }
    });
  }

  public List<Flight> sortByDestCode(List<Flight> flightList, boolean ascending) {
    return sortBy(flightList, ascending, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) { return a.dest.compareTo(b.dest); }
    });
  }

  public List<Flight> sortByOriginCity(List<Flight> flightList, boolean ascending) {
    return sortBy(flightList, ascending, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) { return a.originCity.compareTo(b.originCity); }
    });
  }

  public List<Flight> sortByDestCity(List<Flight> flightList, boolean ascending) {
    return sortBy(flightList, ascending, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) { return a.destCity.compareTo(b.destCity); }
    });
  }

  public List<Flight> sortByDuration(List<Flight> flightList, boolean ascending) {
    return sortBy(flightList, ascending, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) {
        int durationA = timeToMinutes(a.arrTime) - timeToMinutes(a.depTime);
        int durationB = timeToMinutes(b.arrTime) - timeToMinutes(b.depTime);
        return durationA - durationB;
      }
    });
  }


  // returns list of specified dates sorted by date, else returns full list sorted by date
  public List<Flight> getDateRange(List<Flight> flightList, boolean ascending, int startDate, int endDate) {
    int startIdx = -1;
    int endIdx = -1;
    List<Flight> fl = dateSort(flightList, ascending);

    int i = 0;
    String dateString = (startDate<10) ? ("0" + startDate) : ("" + startDate);
    while(i<fl.size() && startIdx == -1){
      if(fl.get(i).flDate.equals("01/" + dateString + "/2022")){
        startIdx = i;
      }
      i++;
    }

    i = 0;
    dateString = (endDate<10) ? ("0" + endDate) : ("" + endDate);
    while(i<fl.size() && endIdx == -1){
      if(fl.get(i).flDate.equals("01/" + dateString + "/2022")){
        endIdx = i;
      }
      i++;
    }

    if(startIdx != -1 && endIdx != -1){
      return fl.subList(startIdx, endIdx);
    } else {
      return fl;
    }
  }

  public List<Flight> getFlightRange(List<Flight> flightList, String airportCode) {
    List<Flight> flightRange = new ArrayList<Flight>();
    for(int i = 0; (i<flightList.size()); i++){
      if(flightList.get(i).origin.equals(airportCode)||flightList.get(i).dest.equals(airportCode)){
        flightRange.add(flightList.get(i));
      }
    }
    return(flightRange);
  }


  public List<Airport> sortByBusiest(List<Flight> flightList, boolean ascending) {
    final int dir = ascending ? 1 : -1;
    ArrayList<Airport> airports = getAirports(flightList);
    Collections.sort(airports, new Comparator<Airport>() {
      public int compare(Airport a, Airport b) {
        return dir * (a.flightCount - b.flightCount);
      }
    });
    return airports;
  }

  public List<Airport> sortByReliability(List<Flight> flightList, boolean ascending) {
    final int dir = ascending ? 1 : -1;
    ArrayList<Airport> airports = getAirports(flightList);
    Collections.sort(airports, new Comparator<Airport>() {
      public int compare(Airport a, Airport b) {
        return dir * (a.cancelledOrDiverted - b.cancelledOrDiverted);
      }
    });
    return airports;
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
            airports.get(i).cancelledOrDiverted += ((int)Float.parseFloat(f.cancelled) + (int)Float.parseFloat(f.diverted));
          }
        }
        if (position == -1) {
          Airport newAirport = new Airport();
          newAirport.aberviation = a;
          newAirport.city = cities[j];
          newAirport.flightCount = 1;
          newAirport.cancelledOrDiverted = ((int)Float.parseFloat(f.cancelled) + (int)Float.parseFloat(f.diverted));
          airports.add(newAirport);
        }
      }
    }
    return airports;
  }

  private int timeToMinutes(String time) {
    if (time == null || time.isEmpty()) return -1;
    int t = (int)Float.parseFloat(time.trim());
    return (t / 100) * 60 + (t % 100);
  }

  private int getLateness(Flight f) {
    int scheduled = timeToMinutes(f.crsArrTime);
    int actual = timeToMinutes(f.arrTime);
    if (scheduled < 0 || actual < 0) return 0;
    return actual - scheduled;
  }
}
