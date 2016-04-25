package ch.epfl.bachelor.projet;

import java.io.*;
import java.rmi.UnexpectedException;

/**
 * Created by andre on 22/04/2016.
 */
public class DataReader {

    private String name;
    private File data;
    private DataHolder holder;

    public DataReader(String name, DataHolder holder){
        this.name=name;
        data = new File(Main.dataPath+"/"+name+".csv");
        this.holder = holder;
    }

    public void read() throws IOException {
        BufferedReader  reader = new BufferedReader(new FileReader(data));
        String next = reader.readLine();
        String[] tabLine = null;
        while((next = reader.readLine()) != null) {
            tabLine = next.split(",");
            if(tabLine.length!=3){
                throw new UnexpectedException("");
            }
            holder.addData(tabLine[0],tabLine[1],tabLine[2]);
        }
    }
}
