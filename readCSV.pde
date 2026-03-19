/*
CHANGELOG:
T. Byrne, Benchmarks CsvToBean loading across all flight CSV files, 07:30, 19/03/2026

*/

import com.opencsv.CSVReader;
import com.opencsv.bean.CsvToBean;
import com.opencsv.bean.CsvToBeanBuilder;
import java.io.FileReader;
import java.util.List;

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
    List<Flight> flights = loadFlights(path);
    long elapsed = (System.nanoTime() - start) / 1_000_000;

    println(String.format("%-20s %,10d %,10d ms", file, flights.size(), elapsed));
  }

  println("\nDone.");
  exit();
}

List<Flight> loadFlights(String filepath) {
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

String findDataDir() {
  if (new File(sketchPath("flight_tables")).exists())
    return sketchPath("flight_tables") + "/";
  if (new File(sketchPath("../flight_tables")).exists())
    return sketchPath("../flight_tables") + "/";
  println("Warning: could not find flight_tables directory");
  return sketchPath("flight_tables") + "/";
}

void draw() {
}
