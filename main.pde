/*
CHANGELOG:
T. Byrne, Benchmarks ReadCSV loading across all flight CSV files for testing, 07:50, 19/03/2026

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

void draw() {
}
