package ch.epfl.bachelor.projet;

import java.rmi.UnexpectedException;
import java.util.ArrayList;

/**
 * Created by andre on 22/04/2016.
 */
public class DataHolder {
    private ArrayList<Integer> ids;
    private ArrayList<Integer> datesBeforeFlight;
    private ArrayList<Integer> prices;
    private ArrayList<Integer> routes;
    private int currentId;

    public DataHolder(){
        this.datesBeforeFlight = new ArrayList<>();
        this.ids = new ArrayList<>();
        this.prices = new ArrayList<>();
        this.routes = new ArrayList<>();
        currentId=0;
    }

    public void addData(int dateBeforeFlight, int price, int route){
        currentId++;
        datesBeforeFlight.add(currentId,dateBeforeFlight);
        prices.add(currentId,price);
        routes.add(currentId,route);
    }
    public void addData(String dateBeforeFlight, String price, String route){
        addData(new Integer(dateBeforeFlight),new Integer(price), new Integer(route));
    }

    public void smoothData(){

    }

    public boolean hasNext(){
        return false;
    }
    public String getNext(){
        return "";
    }
}
