package ch.epfl.bachelor;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

/**
 * Created by andre on 23/02/2016.
 */
public class CSVwriter {
    private PrintWriter writer;
    private PrintWriter secondWriter;
    private final String filename;
    private ExtraDataWriter extraWriter;
    private PrintWriter singleRouteWriter;
    private int routeNbr;

    public CSVwriter(String fileName,int routeNbr){
        this.filename=fileName;
        try {
            this.routeNbr=routeNbr;
            secondWriter = new PrintWriter(fileName+"_second"+".txt","UTF-8");
            writer  = new PrintWriter(fileName+"_displayer.txt", "UTF-8");
            singleRouteWriter = new PrintWriter(fileName+"_route_"+routeNbr+".txt","UTF-8");
            writer.println("Route,dataTime,flightTime,Price");
            singleRouteWriter.println("dateBeforeFlight, Price");
           // writer.println("Route, dateBeforeFlight, Price");
            secondWriter.print("dateBeforeFlight, Price");
            for(int i=1;i<=17;i++){
                secondWriter.print(", "+"route"+i);
            }
            secondWriter.println();
        } catch (FileNotFoundException | UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        extraWriter = new ExtraDataWriter();
    }

    public void writerLine(long dataDate, int route, double price, long flightDate){
        writer.println((route+1) + "," +(dataDate) + "," + (flightDate)+","+ price);
        if(route+1==routeNbr){
            singleRouteWriter.println((flightDate-dataDate)+","+price);
        }
        secondWriter.print((flightDate-dataDate)+","+price);
        for(int i=1;i<=17;i++){
            if((route+1)==i){
                secondWriter.print(","+1);
            }else{
                secondWriter.print(","+0);
            }
        }
        secondWriter.println();
        extraWriter.writerLine(route, dataDate, flightDate, price);
    }

    public void close(){
        System.out.println("Writing is finished.");
        writer.flush();
        writer.close();
        extraWriter.close();
        new CSVchecker(filename);
    }
}
