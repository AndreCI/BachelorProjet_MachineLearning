package ch.epfl.bachelor.projet;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

/**
 * Created by andre on 22/04/2016.
 */
public class DataWriter {

    private DataHolder holder;
    private PrintWriter writer;
    private String name;

    public DataWriter(String name, DataHolder holder){
        try {
            this.writer = new PrintWriter(name+".csv", "UTF-8");
            writer.println("DateBeforeFlight, Price");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        this.holder=holder;
        this.name=name;
    }

    public void write(){
        while(holder.hasNext()){
            writer.println(holder.getNext());
        }
    }
}
