package basic;

//Sqrt.java: wenlong
//code exercise about inheritance in java
//1. interfaces: the main advantage of interfaces is dynamic dispatch;
//               Interfaces provide a mechanism for specifying a relationship between otherwise unrelated classes,
//               typically by specifying a set of common methods that each implementing class must contain.
//               Clinet can only interact with object through listed methods.

//specify the API
//The interface is used to establish a protocol between classes
//All classes that implement this particular interface will look like this
//An interface is more than an abstract class, since it allows you to perform
// a variation of multiple inheritance by creating a class that can be upcast to more than one base type
interface DifferentiableFunction
{
    double eval(double x);
    double diff(double x);
}

//implements says "The interface is what it looks like, but now I'm going to sya how it workds"
//once we've implemented an interface, that implementation becomes an ordinary class
public class Sqrt implements DifferentiableFunction
{
    private double c;

    public Sqrt(double c)
    {
        this.c = c;
    }

    //return f(x) = c - x2
    public double eval(double x)
    {
        return c - x*x;
    }

    //return f'(x) = -2x
    public double diff(double x)
    {
        return -2 * x;
    }
    
}

