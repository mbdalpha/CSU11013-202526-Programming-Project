/*
CHANGELOG:
T. Byrne, Sorts flight lists by lateness, date, and airport, 08:50, 19/03/2026
T. Byrne, Adds sorting by busyness for airports, 15:40, 19/03/2026

*/

import java.util.Collections;
import java.util.Comparator;
import java.util.ArrayList;

class SortFlights {
  public static final boolean ASCENDING = true;
  public static final boolean DESCENDING = false;

  public List<Flight> latenessSort(List<Flight> flightList, boolean ascending) {
    final int dir = ascending ? 1 : -1;
    List<Flight> sorted = new ArrayList<Flight>(flightList);
    Collections.sort(sorted, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) {
        return dir * (getLateness(a) - getLateness(b));
      }
    });
    return sorted;
  }

  public List<Flight> dateSort(List<Flight> flightList, boolean ascending) {
    final int dir = ascending ? 1 : -1;
    List<Flight> sorted = new ArrayList<Flight>(flightList);
    Collections.sort(sorted, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) {
        return dir * a.flDate.compareTo(b.flDate);
      }
    });
    return sorted;
  }

  public List<Flight> sortByOriginCode(List<Flight> flightList, boolean ascending) {
    final int dir = ascending ? 1 : -1;
    List<Flight> sorted = new ArrayList<Flight>(flightList);
    Collections.sort(sorted, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) {
        return dir * a.origin.compareTo(b.origin);
      }
    });
    return sorted;
  }

  public List<Flight> sortByDestCode(List<Flight> flightList, boolean ascending) {
    final int dir = ascending ? 1 : -1;
    List<Flight> sorted = new ArrayList<Flight>(flightList);
    Collections.sort(sorted, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) {
        return dir * a.dest.compareTo(b.dest);
      }
    });
    return sorted;
  }

  public List<Flight> sortByOriginCity(List<Flight> flightList, boolean ascending) {
    final int dir = ascending ? 1 : -1;
    List<Flight> sorted = new ArrayList<Flight>(flightList);
    Collections.sort(sorted, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) {
        return dir * a.originCity.compareTo(b.originCity);
      }
    });
    return sorted;
  }

  public List<Flight> sortByDestCity(List<Flight> flightList, boolean ascending) {
    final int dir = ascending ? 1 : -1;
    List<Flight> sorted = new ArrayList<Flight>(flightList);
    Collections.sort(sorted, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) {
        return dir * a.destCity.compareTo(b.destCity);
      }
    });
    return sorted;
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

  private int timeToMinutes(String time) {
    if (time == null || time.isEmpty()) return -1;
    int t = Integer.parseInt(time.trim());
    return (t / 100) * 60 + (t % 100);
  }

  private int getLateness(Flight f) {
    int scheduled = timeToMinutes(f.crsArrTime);
    int actual = timeToMinutes(f.arrTime);
    if (scheduled < 0 || actual < 0) return 0;
    return actual - scheduled;
  }
}
