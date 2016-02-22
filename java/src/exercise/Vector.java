package exercise;

public class Vector {
   //1. encapsulate the data type, also hide design decisions
   //2. immutability - final gives the promising to assign a value only once,
	// either in an initializer of in the constructor
   private final int N; // length of the vector
   private double[] data; // array of vector
   
   //
   public Vector(int N){
	   this.N = N;
	   this.data = new double[N];
   }
   
   public Vector(double[] data){
	   N = data.length;
	   
	   // defensive copy
	   this.data = new double[N];
	   for(int i =0; i< N; i++){
		   this.data[i] = data[i];
	   }
   }
   
   public Vector plus(Vector that){
	   if(this.N != that.N){
		   throw new RuntimeException();
	   }
	   
	   Vector c = new Vector(N);
	   for(int i=0; i< N; i++){
		   c.data[i] = this.data[i] + that.data[i];
	   }
	   
	   return c; // return vector
   }
   
   public String toString(){
	   StringBuilder s = new StringBuilder();
	   
	   s.append("(");
	   for(int i=0; i< N; i++){
		   s.append(data[i]);
		   if(i<N-1)
			   s.append(", ");
	   }
	   s.append(")");
	   return s.toString();
   }
   
   //test
   public static void main(String[] args){
	   //int N = Integer.parseInt(args[0]);
	   //int T = Integer.parseInt(args[1]);
	   
	   double[] xdata = {1.0, 2.0, 3.0, 4.0};
	   double[] ydata = {5.0, 2.0, 4.0, 1.0};
	   
	   Vector x = new Vector(xdata);
	   Vector y = new Vector(ydata);
	   
	   System.out.println("x + y = " + x.plus(y));
   }
}
