package ch.epfl.bachelor.projet;

/**
 * Created by andre on 09/06/2016.
 */
public class TripleStuff {
    private double key;
    private double value;
    private int route;
    public TripleStuff(double key, double value, int route){
        this.key=key;
        this.value=value;
        this.route=route;
    }

    public double getkey(){
        return key;
    }
    public double getV(){
        return value;
    }
    public double getR(){
        return route;
    }
}
