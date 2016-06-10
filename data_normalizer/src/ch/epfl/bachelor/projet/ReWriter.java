package ch.epfl.bachelor.projet;

import java.io.*;
import java.util.*;

/**
 * Created by andre on 05/06/2016.
 */
public class ReWriter {
    private PrintWriter writer;
    private TreeMap<Double,Double> datas;
    private ArrayList<Double> keys;
    private ArrayList<Integer> routes;
    private ArrayList<Double> values;
    private ArrayList<TripleStuff> a;
    private double maxXValue = 0;
    private double maxYValue = 0;
    private final File inFile;

    public ReWriter(File in, String filename){
        datas = new TreeMap<>();
        inFile=in;
        values = new ArrayList<>();
        keys = new ArrayList<>();
        routes = new ArrayList<>();
        a=new ArrayList<>();
        try {
            writer = new PrintWriter(filename, "UTF-8");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        scan();
        read();
        write();
    }
    public void scan(){
        System.out.println("Scan started!");
        String lineData[] =  {};

        try {
            BufferedReader  reader = new BufferedReader(new FileReader(inFile));
            String line=reader.readLine();
            while((line=reader.readLine())!=null){
                lineData=line.split(",");
                double xVal =Double.parseDouble(lineData[0]);
                double yVal = Double.parseDouble(lineData[1]);
                if(xVal>maxXValue){
                    maxXValue=xVal;
                }
                if(yVal>maxYValue){
                    maxYValue=yVal;
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("Scan ended.");
    }
    public void read(){
        System.out.println("Reading Started!");
    int i=0;
        try {
            BufferedReader  reader = new BufferedReader(new FileReader(inFile));
            String line=reader.readLine();
            String lineData[];
            while((line=reader.readLine())!=null){
                lineData=line.split(",");
                int route = Integer.parseInt(lineData[0]);
                double xVal = Double.parseDouble(lineData[1]);
                double yVal = Double.parseDouble(lineData[2]);

                routes.add(route);
                keys.add(xVal);
                values.add(yVal);
                a.add(new TripleStuff(xVal,yVal,route));

                xVal = xVal/maxXValue;
                yVal = yVal/maxYValue;
                if(datas.containsKey(xVal)){
                   // System.err.println("Map contains data at indice "+xVal);
                    i++;
                }else{
                    datas.put(xVal,yVal);
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("Reading ended. "+i+" conflits reported...");
    }
    public void write(){
        System.out.println("Writing started!");
        Collections.sort(a, new Comparator<TripleStuff>() {
            @Override
            public int compare(TripleStuff o1, TripleStuff o2) {
                return Double.compare(o1.getkey(),o2.getkey());
            }
        });
        try {
            PrintWriter writerTest = new PrintWriter("TesterForUniformization.txt","UTF-8");
            PrintWriter writerRoute = new PrintWriter("csv_trend_route.txt","UTF-8");
        for(Double k : datas.keySet()){
            writerTest.println(k+","+datas.get(k));
            writer.println(datas.get(k));
        }
            for(TripleStuff t : a){
                writerRoute.println(t.getkey()+","+t.getV()+","+t.getR());
            }
        writer.close();
            writerTest.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        System.out.println("Writing ended.");
    }

}
