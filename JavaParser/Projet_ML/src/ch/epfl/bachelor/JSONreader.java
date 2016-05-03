package ch.epfl.bachelor;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by andre on 22/02/2016.
 */
public class JSONreader {
    private static ArrayList<String> currencys;
    private File file;
    private long uTimeCurrentDay;
    private int route;
    private CSVwriter writer;
    private static String routeToWrite;
    private boolean notYetWritten;
    private DataHolder dataHolder;

    public JSONreader(File file, long uTimeCurrentDay, int route, CSVwriter writer, ArrayList<String> currencys, String routeToWrite, DataHolder dataHolder){
        if(!file.getName().endsWith(".txt")){
            throw new IllegalArgumentException();
        }
        this.dataHolder=dataHolder;
        notYetWritten=true;
        this.routeToWrite=routeToWrite;
        this.currencys = currencys;
        this.file = file;
        this.uTimeCurrentDay = uTimeCurrentDay;
        this.route = route;
        this.writer = writer;
    }

    public void read(){
        try {
            BufferedReader  reader = new BufferedReader(new FileReader(file));
            String data = reader.readLine();
            JSONParser jsonParser = new JSONParser();
            if(!data.endsWith(">")) {
                JSONArray array = (JSONArray) jsonParser.parse(data);
                for (int i = 0; i < array.size(); i++) {
                    JSONObject currentData = (JSONObject) jsonParser.parse(array.get(i).toString());
                    JSONArray flights = (JSONArray) currentData.get("Flights");
                    if(flights.size()>=1) {
                        JSONObject e = (JSONObject) flights.get(0);
                        double price = checkAndChangeCurrency((String) currentData.get("MinimumPrice"));
                        long flightDepartureTime = getUnixTime((String) currentData.get("CurrentDate"), (String) e.get("STD"));
                        if (price != 0) {
                            if(Main.loopNumber==0) {
                                dataHolder.addValueForAveragePrice(route, price, new Date(flightDepartureTime*1000));
                                dataHolder.addDataForAverageBiggestPriceChange(route,flightDepartureTime, price);

                                Date departureTime = new Date(flightDepartureTime*1000);
                                int month = departureTime.getMonth();
                                writer.writerLine(uTimeCurrentDay, route, price, flightDepartureTime, month);
                            }else if(Main.loopNumber==1){
                                dataHolder.addDataForBiggestPriceChange(route,uTimeCurrentDay,flightDepartureTime,price);
                            }
                        }
                    }
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    private double getCurrency(String price){
        int i =0;
        while(!Character.isDigit(price.charAt(i))){
            i++;
        }
        String currency;
        switch (route+1){
            case 2 : currency = "Ft";
                break;
            case  5 : currency = "kr";
                break;
            case 6 : currency = "lei";
                break;
            case 7 : currency = "MKD";
                break;
            case 8 : currency = "MKD";
                break;
            case 10 : currency = "Ft";
                break;
            case 12 : currency = "Livre";
                break;
            case 13 : currency = "Livre";
                break;
            case 14 : currency = "lei";
                break;
            case 15 : currency = "lei";
                break;
            case 16 : currency = "Ft";
                break;
            case 18 : currency = "zT";
                break;
            default: currency = "€";
        }

        if(!routeToWrite.equals("no") & notYetWritten){
            notYetWritten = false;
            dataHolder.addInfoOnRoute(route, routeToWrite + " ; currency : " + currency);
        }
        return Double.parseDouble(price.substring(i, price.length()).replaceAll(",", ""));
    }

    private double checkAndChangeCurrency(String price){
        double value = getCurrency(price);
        switch (route+1){
            case 2 : value = value * 0.00322611495;
                break;
            case 5 : value = value * 0.106769;
                break;
            case 6 : value = value * 0.223387967;
                break;
            case 7 : value = value * 0.0162462486;
                break;
            case 8 : value = value * 0.0162462486;
                break;
            case 10 : value = value * 0.00322611495;
                break;
            case 12 : value =  value * 1.26340215;
                break;
            case 13 : value =  value * 1.26340215;
                break;
            case 14 : value = value * 0.223387967;
                break;
            case 15 : value = value * 0.223387967;
                break;
            case 16 : value = value * 0.0369684845;
                break;
            case 18 : value = value * 0.22876;
                break;
            default: value = value;
                break;
        }
        return Math.floor(value*100)/100;
/*
        if(price.startsWith("€")){
            value =  value;
        }else if(price.startsWith("kr")){
            value = value * 0.106769;
        }else if(price.startsWith("lei")){
            value = value * 0.223387967;
        }else if(price.startsWith("MKD")){
            value = value * 0.0162462486;
        }else if(price.startsWith("Ft")){
            value = value * 0.00322611495;
        }else if(price.startsWith("K??")){ //0,0369684845 tcheque -> euro
            value = value * 0.0369684845;
        }else if(route == 9 || route == 11 || route == 17) {
            value = value; //euro : BGY_OTP : 9/CRL_WAW : 11/VKO_BUD : 17
        }else if(price.startsWith("??") && (route == 12|| route == 13)){//1,26340215 Livre->euro
            value =  value * 1.26340215; // livre : LTN_OTP : 12/LTN_PRG : 13
        }else if(price.startsWith("z??")){
            value = value * 0.22876;
        }else{ //DecimalFormat Class
            try {
                throw new ParseException(0);
            } catch (ParseException e) {
                System.out.println(price + " " + route);
             //   e.printStackTrace();
            }
        }
        return Math.floor(value*100)/100;*/
    }

    private long getUnixTime(String date, String departureTime){
        DateFormat df = new SimpleDateFormat("HH:mm/dd/MM/yyyy");
        Date time = new Date();
        try {
            time = df.parse(departureTime+"/"+date);
            Date current = new Date(uTimeCurrentDay*1000);
            if(current.compareTo(time)>=0){
                System.out.println(current.toString() + "  " +time.toString());
            }
        } catch (java.text.ParseException e) {
            e.printStackTrace();
        }
        return time.getTime()/1000;
    }

}
