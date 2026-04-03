/*
CHANGELOG:
T. Byrne, Benchmarks CsvToBean loading across all flight CSV files, 07:30, 19/03/2026
T. Byrne, Refactored into ReadCSV class that loads flight data, 07:50, 19/03/2026
T. Byrne, Fixes bug in reading, 10:15, 19/03/2026
T. Byrne, Moves from using OpenCSV to Kryo, improving the speed it takes to load the database in memory, 15:50, 24/03/2026
T. Byrne, improves code commenting, 13:00, 03/04/2026

*/

import com.esotericsoftware.kryo.Kryo;
import com.esotericsoftware.kryo.io.Input;
import com.esotericsoftware.kryo.io.Output;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;

// ReadCSV loads flight data by using the fast Kryo .bin file if available or else reads the CSV manually to create its own .bin file
class ReadCSV {
  private List<Flight> flights;

  ReadCSV(String filepath) {
    String kryoPath = filepath.replaceAll("\\.csv$", ".bin");
    File kryoFile = new File(kryoPath);

    if (kryoFile.exists()) {
      flights = KryoHelper.load(kryoPath);   // fast path: binary cache
    } else {
      flights = CSVParser.parse(filepath);    // slow path: parse raw CSV
      KryoHelper.save(flights, kryoPath);     // save cache for next run
    }
  }

  List<Flight> getFlights() {
    return flights;
  }
}

// KryoHelper handles serialising/deserialising the flight list to a binary file.
// Kryo is a fast Java serialisation library, we register ArrayList and Flight
// with fixed IDs so the binary format stays stable between runs - otherwise
// depending on which order classes load the auto-assigned IDs can cause problems
static class KryoHelper {
  private static final int BUFFER_SIZE = 1024 * 1024; // 1MB read/write buffer, prevents having to go back and forth with disk constantly

  static Kryo newKryo() {
    Kryo kryo = new Kryo();
    kryo.register(ArrayList.class, 10);
    kryo.register(Flight.class, 11);
    return kryo;
  }

  static ArrayList<Flight> load(String path) {
    try {
      Input input = new Input(new BufferedInputStream(new FileInputStream(path), BUFFER_SIZE));
      ArrayList<Flight> list = newKryo().readObject(input, ArrayList.class);
      input.close();
      return list;
    }
    catch (Exception e) {
      System.out.println("Error loading Kryo file " + path + ": " + e.getMessage());
      return new ArrayList<Flight>();
    }
  }

  static void save(List<Flight> flights, String path) {
    try {
      Output output = new Output(new BufferedOutputStream(new FileOutputStream(path), BUFFER_SIZE));
      newKryo().writeObject(output, new ArrayList<Flight>(flights));
      output.close();
    }
    catch (Exception e) {
      System.out.println("Error saving Kryo file " + path + ": " + e.getMessage());
    }
  }
}

// CSVParser manually parses the flight CSV (no external library),
// used for when there is no .bin file exising for a given CSV
static class CSVParser {
  static ArrayList<Flight> parse(String filepath) {
    ArrayList<Flight> list = new ArrayList<Flight>();
    try {
      BufferedReader br = new BufferedReader(new FileReader(filepath));
      String headerLine = br.readLine();
      if (headerLine == null) return list;

      String[] headers = splitLine(headerLine);
      HashMap<String, Integer> columnIndex = new HashMap<String, Integer>();
      for (int i = 0; i < headers.length; i++) {
        columnIndex.put(strip(headers[i]), i);
      }

      String line;
      while ((line = br.readLine()) != null) {
        if (line.trim().isEmpty()) continue;
        String[] vals = splitLine(line);
        Flight f = buildFlight(vals, columnIndex);
        list.add(f);
      }
      br.close();
    }
    catch (Exception e) {
      System.out.println("Error parsing CSV " + filepath + ": " + e.getMessage());
    }
    return list;
  }

  private static Flight buildFlight(String[] vals, HashMap<String, Integer> idx) {
    Flight f = new Flight();
    f.flDate      = col(vals, idx, "FL_DATE");
    f.carrier     = col(vals, idx, "MKT_CARRIER");
    f.flightNum   = col(vals, idx, "MKT_CARRIER_FL_NUM");
    f.origin      = col(vals, idx, "ORIGIN");
    f.originCity  = col(vals, idx, "ORIGIN_CITY_NAME");
    f.originState = col(vals, idx, "ORIGIN_STATE_ABR");
    f.originWac   = col(vals, idx, "ORIGIN_WAC");
    f.dest        = col(vals, idx, "DEST");
    f.destCity    = col(vals, idx, "DEST_CITY_NAME");
    f.destState   = col(vals, idx, "DEST_STATE_ABR");
    f.destWac     = col(vals, idx, "DEST_WAC");
    f.crsDepTime  = col(vals, idx, "CRS_DEP_TIME");
    f.depTime     = col(vals, idx, "DEP_TIME");
    f.crsArrTime  = col(vals, idx, "CRS_ARR_TIME");
    f.arrTime     = col(vals, idx, "ARR_TIME");
    f.cancelled   = col(vals, idx, "CANCELLED");
    f.diverted    = col(vals, idx, "DIVERTED");
    f.distance    = col(vals, idx, "DISTANCE");

    if (f.flDate != null && f.flDate.contains(" ")) {
      f.flDate = f.flDate.split(" ")[0];
    }
    return f;
  }

  private static String col(String[] vals, HashMap<String, Integer> idx, String name) {
    Integer i = idx.get(name);
    if (i == null || i >= vals.length) return "";
    return strip(vals[i]);
  }

  private static String strip(String s) {
    return s.trim().replaceAll("^\"|\"$", "");
  }

  private static String[] splitLine(String line) {
    ArrayList<String> fields = new ArrayList<String>();
    boolean inQuotes = false;
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < line.length(); i++) {
      char ch = line.charAt(i);
      if (ch == '"') {
        inQuotes = !inQuotes;
        sb.append(ch);
      } else if (ch == ',' && !inQuotes) {
        fields.add(sb.toString());
        sb = new StringBuilder();
      } else {
        sb.append(ch);
      }
    }
    fields.add(sb.toString());
    return fields.toArray(new String[0]);
  }
}
