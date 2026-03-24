/*
CHANGELOG:
T. Byrne, Flight bean: CsvBindByName annotations for OpenCSV CsvToBean mapping, 07:30, 19/03/2026
T. Byrne, Moves from using OpenCSV to Kryo, improving the speed it takes to load the database in memory, 15:50, 24/03/2026

*/

public class Flight {
  public String flDate;
  public String carrier;
  public String flightNum;
  public String origin;
  public String originCity;
  public String originState;
  public String originWac;
  public String dest;
  public String destCity;
  public String destState;
  public String destWac;
  public String crsDepTime;
  public String depTime;
  public String crsArrTime;
  public String arrTime;
  public String cancelled;
  public String diverted;
  public String distance;
}
