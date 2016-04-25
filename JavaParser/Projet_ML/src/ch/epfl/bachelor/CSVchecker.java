package ch.epfl.bachelor;

import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Scanner;

/**
 * Created by andre on 25/02/2016.
 */
public class CSVchecker {
    private ArrayList<Integer> routes;
    private ArrayList<Date> dataDates;
    private ArrayList<Date> flightDates;
    private ArrayList<Double> prices;
    private File csvToCheck = null;
    private PrintWriter logWriter;

    public CSVchecker(String filename) {
        Main.endTime = System.nanoTime();
        System.out.println("0 : exit now; else : gather more data.");
        Scanner sc = new Scanner(System.in);
        if (0 != 0) {

            csvToCheck = new File("C:/Users/andre/IdeaProjects/Projet_ML/" + filename + ".txt");
            routes = new ArrayList<>();
            dataDates = new ArrayList<>();
            flightDates = new ArrayList<>();
            prices = new ArrayList<>();
            try {
                logWriter = new PrintWriter("log.txt", "UTF-8");
                logWriter.println("Writing log for CSVchecker at " + (System.nanoTime() - Main.startTime));
                check();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            System.out.println("Checking is finished.");
            logWriter.close();
        }
    }

    private void check() throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(csvToCheck));
        String line = reader.readLine();
        long oldDataDateU = 2;
        while((line = reader.readLine())!=null) {
            String data[] = line.split(",");
            int route = Integer.parseInt(data[0]);
            double price = Double.parseDouble(data[3]);
            long dataDateU = Long.parseLong(data[1]);
            long flightDateU = Long.parseLong(data[2]);
            Date dataDate = new Date(dataDateU*1000);
            Date flightDate = new Date(flightDateU*1000);
            if(dataDateU<oldDataDateU){
                logWriter.println("Dates went wrong");
            }
            oldDataDateU = dataDateU;
            if(flightDates.contains(flightDate)){
                int idx = flightDates.indexOf(flightDate);
                if(route==routes.get(idx)){
                    int occurrences = Collections.frequency(flightDates, flightDate);
                    logWriter.print("route went wrong : "+(occurrences+1)+ " occ found ");
                    logWriter.print("; price :"+price + " ; route : "+route+ " ; dataDate : " + dataDate.toString() +" ; flightDate : "+flightDate.toString());
                    logWriter.println(" ;;; routeIdx : " + idx);
                }
            }
            flightDates.add(flightDate);
            prices.add(price);
            routes.add(route);
            dataDates.add(dataDate);

            if(price>1000 || price <=0){
                logWriter.print("Price went wrong");
                logWriter.println("; price :"+price + " ; route : "+route+ " ; dataDate : " + dataDate.toString() +" ; flightDate : "+flightDate.toString());
            }
            if(dataDateU>flightDateU){
                logWriter.print("Dates went wrong");
                logWriter.println("; price :"+price + " ; route : "+route+ " ; dataDate : " + dataDate.toString() +" ; flightDate : "+flightDate.toString());
            }
        }

    }
}
