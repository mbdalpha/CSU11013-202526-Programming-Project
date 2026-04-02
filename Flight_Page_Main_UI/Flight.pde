class Flight {
  String flDate;
  String airline;
  String flightNum;
  String origin;
  String originCity;
  String originState;
  String originWac;
  String dest;
  String destCity;
  String destState;
  String destWac;
  String crsDepTime;
  String depTime;
  String crsArrTime;
  String arrTime;
  String cancelled;
  String diverted;
  String distance;

  Flight(String line) {
    String[] cols = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");
    if (cols.length >= 18) {
      this.flDate = cols[0].replaceAll("\"", "").trim();
      this.airline = cols[1].replaceAll("\"", "").trim();
      this.flightNum = cols[2].replaceAll("\"", "").trim();
      this.origin = cols[3].replaceAll("\"", "").trim();
      this.originCity = cols[4].replaceAll("\"", "").trim();
      this.originState = cols[5].replaceAll("\"", "").trim();
      this.originWac = cols[6].replaceAll("\"", "").trim();
      this.dest = cols[7].replaceAll("\"", "").trim();
      this.destCity = cols[8].replaceAll("\"", "").trim();
      this.destState = cols[9].replaceAll("\"", "").trim();
      this.destWac = cols[10].replaceAll("\"", "").trim();
      this.crsDepTime = cols[11].replaceAll("\"", "").trim();
      this.depTime = cols[12].replaceAll("\"", "").trim();
      this.crsArrTime = cols[13].replaceAll("\"", "").trim();
      this.arrTime = cols[14].replaceAll("\"", "").trim();
      this.cancelled = cols[15].replaceAll("\"", "").trim();
      this.diverted = cols[16].replaceAll("\"", "").trim();
      this.distance = cols[17].replaceAll("\"", "").trim();
    }
  }
}
