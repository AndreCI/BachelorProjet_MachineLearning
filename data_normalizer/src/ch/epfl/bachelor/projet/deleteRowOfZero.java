package ch.epfl.bachelor.projet;

import java.io.*;

/**
 * Created by andre on 09/06/2016.
 */
public class deleteRowOfZero {
    File file;
    PrintWriter writer;

    public deleteRowOfZero(File file, String filename) {
        this.file = file;
        try {
            writer = new PrintWriter(filename, "UTF-8");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        readAndWrite();
    }

    public void readAndWrite() {
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader(file));
            String line = reader.readLine();
            String lineData[];
            while ((line = reader.readLine()) != null) {
                lineData = line.split(",");
                boolean monthOk = true;
                boolean routeOk = true;
                System.out.println(line);
                for (int i = 0; i < 12; i++) {

                    if(Integer.parseInt(lineData[i+21])==10){System.err.println("WRONG");}
                    if (Integer.parseInt(lineData[i + 21]) == 1) {
                        monthOk = true;
                    }
                }
                for (int i = 0; i < 17; i++) {
                    if(Integer.parseInt(lineData[i+3])==10){System.err.println("WRONG");}
                    if (Integer.parseInt(lineData[i + 3]) == 1) {
                        routeOk = true;
                    }
                }
                if (routeOk && monthOk) {
                    int i = 0;
                    for (i = 0; i < lineData.length - 1; i++) {
                        writer.print(lineData[i] + ",");
                    }
                    writer.println(lineData[i]);
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
