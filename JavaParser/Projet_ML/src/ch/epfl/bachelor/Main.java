package ch.epfl.bachelor;

import java.io.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.concurrent.TimeUnit;

public class Main {

    private static PrintWriter infoWriter;
    private static ArrayList<String> routes;
    private static ArrayList<String> routes2;
    private static ArrayList<String> currencys;
    private static DataHolder dataHolder;
    public static long startTime = System.nanoTime();
    public static long endTime;
    public static int loopNumber = 0;

    public static void main(String[] args) {
        final File largeDataPath = new File("c:/Users/andre/IdeaProjects/Projet_ML/data/data/data/Large data set/");
        final File smallDataPath = new File("c:/Users/andre/IdeaProjects/Projet_ML/data/data/data/Small data set/");

        if(!(largeDataPath.isDirectory()) || !(smallDataPath.isDirectory())){
            try {
                throw new IOException("Error reading Large data set or Small data set : not a directory?!");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        routes = new ArrayList<>();
        routes2 = new ArrayList<>();
        try {
            infoWriter = new PrintWriter("info.txt", "UTF-8");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        currencys = new ArrayList<>();
        dataHolder = new DataHolder();
      //  for(int k=9; k<18;k++) {
        int k =1;
            CSVwriter writer = new CSVwriter("dataCSV", k);
            for (loopNumber = 0; loopNumber < 2; loopNumber++) {
                decodeForDataPath(largeDataPath, writer);
                decodeForDataPath(smallDataPath, writer);
                dataHolder.reset();
                System.out.println("Loop : " + loopNumber + " sucessfully done in " + (System.nanoTime() - startTime) / Math.pow(10, 9) + " seconds.");
            }
            for (int i = 0; i < dataHolder.getNbrRoute(); i++) {
                infoWriter.println(dataHolder.getInfoOnRoute(i) + " ; average (in €) : " + Math.floor(dataHolder.getAveragePrice(i) * 100) / 100 + " ; averageDateOfBiggestChange : " +
                        dataHolder.getDateOfBiggestPriceChange(i) + " days.");
                infoWriter.println("For this route, the average price change is : " + Math.floor(100 * dataHolder.getAveragePriceChange(i)) / 100);
                for (int j = 0; j < 7; j++) {
                    infoWriter.println("    The day nbr " + (j + 1) + ", the average price is " + Math.floor(dataHolder.getAveragePriceForADay(i, j) * 100) / 100 + " on the route.");
                }


            }


            infoWriter.flush();
            infoWriter.close();
            writer.close();
            System.out.println("Finished in " + (endTime - startTime) / Math.pow(10, 9));

    }
    public static void decodeForDataPath(File data, CSVwriter writer){
        JSONreader reader;
        for(final File dayFolder : data.listFiles()){
            if(!dayFolder.getName().equals("info")){
                long uTime = getUnixTime(dayFolder.getName());
                for(final File txtFile : dayFolder.listFiles()){
                    reader = new JSONreader(txtFile, uTime, getRoute(txtFile.getName()), writer, currencys, getRouteToWrite(txtFile.getName()), dataHolder);
                    reader.read();
                }
            }
        }
    }

    private static String getRouteToWrite(String name){
        if(!routes2.contains(name.substring(0, 7))) {
            routes2.add(name.substring(0, 7));
            return (routes2.get(routes2.size() - 1) + " : " + (routes2.size()));
        }else{
            return new String("no");
        }
    }

    public static int getRoute(String name){
        if(!routes.contains(name.substring(0, 7))){
            routes.add(name.substring(0, 7));
            return routes.size()-1;
        }else{
            return routes.indexOf(name.substring(0,7));
        }
    }

    public static long getUnixTime(String date){
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Date time = new Date();
        try {
            time = df.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return time.getTime()/1000;
    }

}
