/*
CHANGELOG:
T. Byrne, Flight bean: CsvBindByName annotations for OpenCSV CsvToBean mapping, 07:30, 19/03/2026

*/

import com.opencsv.bean.CsvBindByName;

public class Flight {
  @CsvBindByName(column = "FL_DATE")
  public String flDate;

  @CsvBindByName(column = "MKT_CARRIER")
  public String carrier;

  @CsvBindByName(column = "MKT_CARRIER_FL_NUM")
  public String flightNum;

  @CsvBindByName(column = "ORIGIN")
  public String origin;

  @CsvBindByName(column = "ORIGIN_CITY_NAME")
  public String originCity;

  @CsvBindByName(column = "ORIGIN_STATE_ABR")
  public String originState;

  @CsvBindByName(column = "ORIGIN_WAC")
  public String originWac;

  @CsvBindByName(column = "DEST")
  public String dest;

  @CsvBindByName(column = "DEST_CITY_NAME")
  public String destCity;

  @CsvBindByName(column = "DEST_STATE_ABR")
  public String destState;

  @CsvBindByName(column = "DEST_WAC")
  public String destWac;

  @CsvBindByName(column = "CRS_DEP_TIME")
  public String crsDepTime;

  @CsvBindByName(column = "DEP_TIME")
  public String depTime;

  @CsvBindByName(column = "CRS_ARR_TIME")
  public String crsArrTime;

  @CsvBindByName(column = "ARR_TIME")
  public String arrTime;

  @CsvBindByName(column = "CANCELLED")
  public String cancelled;

  @CsvBindByName(column = "DIVERTED")
  public String diverted;

  @CsvBindByName(column = "DISTANCE")
  public String distance;
}
