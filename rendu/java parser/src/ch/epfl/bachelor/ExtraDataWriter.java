package ch.epfl.bachelor;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by andre on 02/03/2016.
 */
public class ExtraDataWriter {
    private PrintWriter writer;
    private Map<Integer,Map<Long, Double>> oldPrices;


    public ExtraDataWriter(){
        try {
            this.writer = new PrintWriter("ExtraData.txt", "UTF-8");
            writer.println("Route,dataTime,timeBeforeFlight,PriceDifference");
            oldPrices = new HashMap<>();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }

    public void writerLine(int route, long dataDate, long flightDate, double price) {
        writer.println((route+1) +","+dataDate+","+(flightDate-dataDate)+","+getOldPrice(route,flightDate));
        upDateOldPrice(route,flightDate,price);
    }

    public void close(){
        System.out.println("Extra Writing is finished");
        writer.flush();
        writer.close();
    }

    public void upDateOldPrice(int route, long flightDate, double price){
        if(oldPrices.containsKey(route)){
            if(oldPrices.get(route).containsKey(flightDate)){
                oldPrices.get(route).put(flightDate, price);
            }else{
                oldPrices.get(route).put(flightDate, price);
            }
        }else{
            oldPrices.put(route, new HashMap<Long, Double>());
            oldPrices.get(route).put(flightDate, price);
        }
    }
    public double getOldPrice(int route, long flightDate){
        double oldPrice=0;
        if(oldPrices.containsKey(route)){
            if(oldPrices.get(route).containsKey(flightDate)){
                oldPrice=oldPrices.get(route).get(flightDate);
            }else{
                oldPrices.get(route).put(flightDate, new Double(0));
            }
        }else{
            oldPrices.put(route, new HashMap<Long, Double>());
        }
        return oldPrice;
    }


}
