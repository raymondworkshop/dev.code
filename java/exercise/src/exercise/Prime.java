package exercise;

public class Prime {
      public static void main(String[] args){	
    	  long N = Long.parseLong(args[0]);
    	  //long N =StdIn.readLong( (long)(args[0]) );
    	  
    	  boolean isPrime = true;
    	  if (N < 2)
    		  isPrime = false;
    	  
    	  for(long i =2; i*i <= N; i++){
    		  
    		  if(N % i == 0){
    			  isPrime = false;
    			  break;
    		  }
    		  
    	  }
    	  
    	  // print out
    	  if(isPrime)
    		  //System.out.println(N + " is prime");
    		  StdOut.println(N + " is prime");
    	  else
    		  //System.out.println(N + " is not prime");
    		  StdOut.println(N + " is not prime");
	}

}
