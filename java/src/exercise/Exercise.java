package exercise;

//string
public class Exercise {
	
   // reverse the string
	public static String Reverse(String src){
		if(src == null){
			return src;
		}
		
		String reverse = "";
		for(int i = src.length()-1; i>=0; i--){
			reverse = reverse + src.charAt(i);
		}
		
		return reverse;
	}
	
	// is prime number
	public static boolean IsPrime(int number){
		for(int i=2; i<number; i++){
			if(number % i == 0){
				return false;
			}
		}
		
		return true;
	}
	
	// Fibonacci
	public static int fib1 (int n){
		if(n == 0 || n == 1){
			return n;		
		}
		
		return fib1(n -1 ) + fib1(n-2);
		
	}
	
	// Fibonacci - iteration
	public static int fib2(int n){
		if(n == 0 || n == 1){
			return n;
		}
		
		int fib=0; //store the intervalue
		int fib1 = 0;
		int fib2 = 1;
		for(int i=2; i <= n; i++){
			fib = fib1 + fib2;
			
			fib1 = fib2;
			fib2 = fib;
		}
		
		return fib;
	}
	
	//test
	public static void main(String args[]){
		String word = "Helloworld";
		String reverse = Reverse(word);
		
		System.out.printf(reverse);
		
		//
		int num = 12;
		System.out.println(fib1(num));
		System.out.println(fib2(num));
	}
}
