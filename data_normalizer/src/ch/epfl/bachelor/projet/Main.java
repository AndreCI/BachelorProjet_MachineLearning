package ch.epfl.bachelor.projet;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;

public class Main {

    public static void main(String[] args) {

        File csv = new File("C:/Users/andre/Documents/Projet/JavaParser/Projet_ML/" + "dataCSV_route_month" + ".txt");
        File d = new File("C:/Users/andre/Documents/Projet/MatLab Script/result/" + "results_TbF_route_month_ 3" + ".txt");
        File cs = new File("C:/Users/andre/Documents/Projet/MatLab Script/data/dataCSV.txt");
        File scfd = new File("C:/Users/andre/Documents/Projet/MatLab Script/data/dataCSV_TbF_route_month.txt");
       // new ReWriter(csv,"data_simple.txt");
       // new VarAndMoyCalculator(d,"value.txt");
        new deleteRowOfZero(scfd,"csv_route_month_TBF.txt");
    }
}
