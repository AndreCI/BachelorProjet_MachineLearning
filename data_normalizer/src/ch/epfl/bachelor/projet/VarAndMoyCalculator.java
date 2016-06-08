package ch.epfl.bachelor.projet;

import java.io.*;
import java.util.ArrayList;

/**
 * Created by andre on 08/06/2016.
 */
public class VarAndMoyCalculator {
    private PrintWriter writer;
    private File file;
    ArrayList<ArrayList<Double>> data;
    ArrayList<Double> moyenne;
    ArrayList<Double> variance;
    private int dataLength;
    private int dataDepth;
    public VarAndMoyCalculator(File file, String fileName){
        try {
            this.file=file;
            moyenne = new ArrayList<>();
            variance = new ArrayList<>();
            data=new ArrayList<>();
            writer=new PrintWriter(fileName,"UTF-8");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        read();
        computeMoy();
        computeVar();
        write();
    }

    public void read(){

        String line= null;
        try {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            line = reader.readLine();
            line = reader.readLine();
            String lineData[];
            lineData = line.split(",");
            dataLength=lineData.length;
            for(int i = 0; i<lineData.length; i++){
                data.add(new ArrayList<Double>());
            }
          do{
                lineData = line.split(",");
                for(int i = 0; i<lineData.length; i++){
                    data.get(i).add(Double.parseDouble(lineData[i]));
                }
            }  while((line=reader.readLine())!=null);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void computeMoy(){
        dataDepth=data.get(0).size();
        for(int j =0; j<dataLength;j++){
            moyenne.add(0.0);
        }
        for(int i = 0; i<dataLength; i++){
            ArrayList<Double> current = data.get(i);
            for(int j=0; j<dataDepth; j++){
                moyenne.set(i,moyenne.get(i)+current.get(j));
            }
            moyenne.set(i,moyenne.get(i)/dataDepth);
        }
    }

    public void computeVar(){
        for(int i =0; i<dataLength; i++){
            ArrayList<Double> current = data.get(i);
            double temp=0;
            for(int j=0; j<dataDepth; j++){
                temp+= Math.pow(current.get(j)-moyenne.get(i),2);
            }
            temp = temp/dataDepth;
            variance.add(temp);
        }
    }

    public void write(){
        for(int i=0;i<dataLength;i++) {
            writer.println("For Param "+i+ ", m="+moyenne.get(i)+" ;var="+variance.get(i));
        }
        
        writer.close();

    }
}
