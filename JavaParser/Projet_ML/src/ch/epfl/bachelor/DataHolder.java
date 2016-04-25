package ch.epfl.bachelor;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by andre on 02/03/2016.
 */
public class DataHolder {
    private Map<Integer, Double> averagePrice;
    private ArrayList<Map<Integer,Double>>  averagePriceForADay;

    private ArrayList<Map<Integer,Integer>> nbrOfDataForDay;
    private Map<Integer, Integer> nbrOfData;
    private Map<Integer, Integer> nbrOfDataForChange;
    private Map<Integer, Integer> nbrOfDataForDate;
    private Map<Integer, String> infoOnRoute;
    private Map<Integer, Integer> averageDateOfBiggestPriceChange;
    private Map<Integer, Double> averagePriceChangeForARoute;
    private Map<Integer,Map<Long, Double>> oldPrices;

    private ArrayList<Long> pairs1;
    private ArrayList<Long> pairs2;
    private ArrayList<Integer> routeOfPairs;


    private int nbrRoute;

    public DataHolder(){
        averagePrice =new HashMap<>();
        nbrOfData= new HashMap<>();
        nbrOfDataForChange= new HashMap<>();
        nbrOfDataForDate= new HashMap<>();
        infoOnRoute=new HashMap<>();
        averageDateOfBiggestPriceChange = new HashMap<>();
        averagePriceChangeForARoute = new HashMap<>();
        oldPrices = new HashMap<>();
        pairs1=new ArrayList<>();
        pairs2 = new ArrayList<>();
        routeOfPairs = new ArrayList<>();
        nbrRoute=0;
        averagePriceForADay = new ArrayList<>();
        nbrOfDataForDay = new ArrayList<>();
        for(int i =0; i<7; i++){
            averagePriceForADay.add(new HashMap<Integer, Double>());
            nbrOfDataForDay.add(new HashMap<Integer, Integer>());
        }

    }
    public void reset(){
        oldPrices = new HashMap<>();
    }

    public void createPairOfRoute(int route, long flightDate1, long flightDate2){
        pairs1.add(flightDate1);
        pairs2.add(flightDate2);
        routeOfPairs.add(route);
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

    /**
     * Give data in order to know what is the average price change for a route, so we can find later when are the biggest price change
     * @param route : what route we are interested in.
     * @param flightDate : used, with the route, as in unique ID for the flight.
     * @param price : the price. We can deduce the change of the price from previous data.
     */
    public void addDataForAverageBiggestPriceChange(int route, long flightDate,double price){
        double change = Math.abs(price - getOldPrice(route, flightDate));
        upDateOldPrice(route, flightDate,price);
        if(change!=0) {
            if (route > nbrRoute) {
                nbrRoute = route;
            }
            if (averagePriceChangeForARoute.containsKey(route)) {
                averagePriceChangeForARoute.put(route, averagePriceChangeForARoute.get(route) + change);
                nbrOfDataForChange.put(route, nbrOfDataForChange.get(route) + 1);
            } else {
                averagePriceChangeForARoute.put(route, change);
                nbrOfDataForChange.put(route, 1);
            }
        }
    }

    /**
     * Give data in order to find when, in day, before the flight, in average, for a route, is the biggest price change.
     * We need to have data (what is the average change) in order to know that.
     * @param route : what route we are interested in.
     * @param currentDate : used to know how many days there is before the flight
     * @param flightDate : used to know how many days there is before the flight
     * @param price : the price of the flight, which we can determine the change of price from others data.
     */
    public void addDataForBiggestPriceChange(int route,long currentDate, long flightDate, double price){
        double change = Math.abs(price - getOldPrice(route, flightDate));
        upDateOldPrice(route, flightDate, price);
        Date currentD = new Date(currentDate*1000);
        Date flightD = new Date(flightDate*1000);
        int diffInDays =(int)((flightD.getTime()-currentD.getTime())/(1000*60*60*24));
        if(diffInDays<0){
            throw new IllegalArgumentException();
        }
        if(averageDateOfBiggestPriceChange.containsKey(route)){
            if(change>getAveragePriceChange(route)){
                averageDateOfBiggestPriceChange.put(route, averageDateOfBiggestPriceChange.get(route)+diffInDays);
                if(!nbrOfDataForDate.containsKey(route)) {
                    nbrOfDataForDate.put(route, 0);
                }
                nbrOfDataForDate.put(route, nbrOfDataForDate.get(route) + 1);

            }
        }else{
            if(change>getAveragePriceChange(route)){
                averageDateOfBiggestPriceChange.put(route, diffInDays);//(long) Math.floor(dateBeforeLeaving*change));
                nbrOfDataForDate.put(route, 1);//(int) Math.floor(1*change));
            }else{
                averageDateOfBiggestPriceChange.put(route, new Integer(0));
            }
        }
    }

    public double getAveragePriceChange(int route){
        return averagePriceChangeForARoute.get(route)/nbrOfDataForChange.get(route);
    }
    public long getDateOfBiggestPriceChange(int route){
        if(Main.loopNumber==0){
            System.err.println("Wrong call of getDateOfBiggestPriceChange");
        }
        if(!averageDateOfBiggestPriceChange.containsKey(route)){
            System.err.println("There is no data!");
        }
        return averageDateOfBiggestPriceChange.get(route)/nbrOfDataForDate.get(route);
    }

    public int getNbrRoute(){
        return nbrRoute;
    }
    public void addInfoOnRoute(int route, String info){
        if(route>nbrRoute){nbrRoute=route;}
        infoOnRoute.put(route, info);
    }

    public String getInfoOnRoute(int route){
        return infoOnRoute.get(route);
    }


    public void addValueForAveragePrice(int route, double value, Date date){
        if(route>nbrRoute){nbrRoute=route;}
        if(averagePrice.containsKey(route)) {
            averagePrice.put(route, averagePrice.get(route) + value);
            nbrOfData.put(route, nbrOfData.get(route)+1);
        }else{
            averagePrice.put(route, value);
            nbrOfData.put(route, 1);
        }
        if(averagePriceForADay.get(date.getDay()).containsKey(route)){
            averagePriceForADay.get(date.getDay()).put(route, averagePriceForADay.get(date.getDay()).get(route) + value);
            nbrOfDataForDay.get(date.getDay()).put(route, nbrOfDataForDay.get(date.getDay()).get(route)+1);
        }else{
            averagePriceForADay.get(date.getDay()).put(route,value);
            nbrOfDataForDay.get(date.getDay()).put(route,1);
        }

    }
    public double getAveragePriceForADay(int route, int day){
        return averagePriceForADay.get(day).get(route)/nbrOfDataForDay.get(day).get(route);
    }

    public double getAveragePrice(int route){
        return averagePrice.get(route)/nbrOfData.get(route);
    }
}
