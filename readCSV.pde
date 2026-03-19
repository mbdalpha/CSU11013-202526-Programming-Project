/*
CHANGELOG:
T. Byrne, Benchmarks CsvToBean loading across all flight CSV files, 07:30, 19/03/2026
T. Byrne, Refactored into ReadCSV class that loads flight data, 07:50, 19/03/2026

*/

import com.opencsv.CSVReader;
import com.opencsv.bean.CsvToBean;
import com.opencsv.bean.CsvToBeanBuilder;
import java.io.FileReader;
import java.util.List;

class ReadCSV {
  private List<Flight> flights;

  ReadCSV(String filepath) {
    flights = loadFlights(filepath);
  }

  private List<Flight> loadFlights(String filepath) {
    try {
      FileReader reader = new FileReader(filepath);
      List<Flight> flights = new CsvToBeanBuilder<Flight>(reader)
        .withType(Flight.class)
        .build()
        .parse();
      reader.close();
      return flights;
    }
    catch (Exception e) {
      println("Error loading " + filepath + ": " + e.getMessage());
      return new java.util.ArrayList<Flight>();
    }
  }

  List<Flight> getFlights() {
    return flights;
  }
}
