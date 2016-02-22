package exercise;
import basic.*;

public class SATmyYear {
	public static void main(String[] args){
		double x = Double.parseDouble(args[0]);
		StdOut.println((Gaussian.Phi(x) - 1019) / 209);
	}

}
