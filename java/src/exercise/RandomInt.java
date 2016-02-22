package exercise;
import basic.*;

public class RandomInt {
	public static void main(String[] args){
		//int N = Integer.parseInt(args[0]);
		int N = StdIn.readInt();
		
		double r = Math.random();
		
		int n = (int)(r * N);
		
		System.out.println("The random integer is: " + n);
		
	}

}
