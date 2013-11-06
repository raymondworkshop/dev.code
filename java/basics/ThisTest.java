//ThisTest.java
// this key words:
// 1. which can be used only inside a non-static method
// 2. it produces the reference to the object that the method has been called for
//
class Person
{
    public void eat(Apple apple)
    {
        Apple peeled = apple.getPeeled();
        System.out.println("Yummy");
    }

}

class Peeler
{
    static Apple peel(Apple apple)
    {
        return apple;
        
    }
    
}

class Apple
{
    Apple getPeeled()
    {
       //2)here, Apple calls Peeler.peel(), a foreign utility method (external to Apple).
        //To pass itself to the foreign method, it must use this
        return Peeler.peel(this);
    }
    
}

public class ThisTest
{
    int i = 0;
    ThisTest increment()
    {
        i++;
        //1) this is in the sense of "this object" or "the current object";
        //this return the reference to the current object via this keyword,
        //multiple operations can easily be performed on the same object
        return this;
    }

    void print()
    {
        System.out.println("i = " + i);
        
    }

    //reference to flower.java
    int petalCount = 0;
    String s = "initial value";

    ThisTest(int petals)
    {
        petalCount  = petals;
        System.out.println("Constructor w/ int arg only, petalCount= " + petalCount);
        
    }

    ThisTest(String ss)
    {
        System.out.println("Constructor w/ String arg only, s= " + ss);
        s =ss;
        
    }

    ThisTest(String s, int petals)
    {
        //3) in the constructor, this makses an explicit call to the constructor that matches that argument list
        // a straightforward way to call other constructors.
        // call to this msut be first statement in constructor, so cann't call two 
        this(petals);
        //this(s); //wrong, cann't call two times

        //since the name of the argument s and the name of the member data s are the same,
        // we can resolve it using this.s, to say that we're referring to the member data
        this.s = s; //put s to the member data
        
        System.out.println("String & int args");
                        
    }
    
    ThisTest()
    {
        this("hi", 47);
        System.out.println("default constructor (no args)");
        
    }
    
    void printPetalCount()
    {
        System.out.println("petalCount = " + petalCount + " s = " + s);
        
    }
        
    public static void main(String[] args)
    {
        ThisTest x = new ThisTest();
        //return the reference to the object x
        x.increment().increment().increment().print(); //3

        //2) use to pass the current object to another method
        new Person().eat(new Apple());

        //3)in a constructor, 
        // this makes an explicit call to the constructor that matches that argument list
        ThisTest x3 = new ThisTest();
        x3.printPetalCount();
        
    }
        
}

