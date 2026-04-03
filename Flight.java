/*
CHANGELOG:
T. Byrne, Flight bean: CsvBindByName annotations for OpenCSV CsvToBean mapping, 07:30, 19/03/2026
T. Byrne, Moves from using OpenCSV to Kryo, improving the speed it takes to load the database in memory, 15:50, 24/03/2026
T. Byrne, improves code commenting, 13:00, 03/04/2026

*/

// data class representing a single flight record from the CSV
public class Flight {
  public String flDate;       // flight date, e.g. "01/15/2022"
  public String carrier;      // airline IATA code, e.g. "AA", "DL"
  public String flightNum;    // marketing carrier flight number
  public String origin;       // origin airport IATA code, e.g. "JFK"
  public String originCity;   // origin city name, e.g. "New York, NY"
  public String originState;  // origin state abbreviation, e.g. "NY"
  public String originWac;    // origin world area code
  public String dest;         // destination airport IATA code
  public String destCity;     // destination city name
  public String destState;    // destination state abbreviation
  public String destWac;      // destination world area code
  public String crsDepTime;   // scheduled departure time (HHMM)
  public String depTime;      // actual departure time (HHMM)
  public String crsArrTime;   // scheduled arrival time (HHMM)
  public String arrTime;      // actual arrival time (HHMM)
  public String cancelled;    // "1" if cancelled, "0" otherwise
  public String diverted;     // "1" if diverted, "0" otherwise
  public String distance;     // flight distance in miles
}
