package ch.epfl.bachelor.projet;

import java.io.IOException;

public class Main {

    public final static String dataPath ="C:/Users/andre/Documents/Projet/data";
    public static void main(String[] args) {
	    DataHolder holder = new DataHolder();
        DataReader reader = new DataReader("",holder);
        DataWriter writer = new DataWriter("data_csv_smooth",holder);

        try {
            reader.read();
            holder.smoothData();
            writer.write();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
