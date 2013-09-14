//Newton.java: wenlong
// Compilation: javac Newton.java Sqrt.java
// Execution: java Newton x

public class Newton 
{
    //find root x such that f(x)=0 using Newton's method,starting at x0
    public static double FindRoot(DifferentiableFunction f, double x0)
    {
        double eps = 1e-15;
        double x = x0;
        double delta = f.eval(x) / f.diff(x);

        while(Math.abs(delta) > (eps / x)){
            x = x - delta;
            delta = f.eval(x) / f.diff(x);
            StdOut.println(x);
        }

        return x;
    }

    //client
    public static void main(String[] args)
    {
        DifferentiableFunction f = new Sqrt(2);
        StdOut.println(FindRoot(f, 2.0));
    }
    
}
