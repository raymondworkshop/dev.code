//StaticTest.java
// basic static knowledge in java
//
package basics;

class Test
{
    //1. static: particular field or method is not tied to any particular object instance of that class.
    //
    //    1)if we want to have only a single piece of storage for a particular field like i,
    //   regardless of how many objects of that class are created, or even if no objects are created.
    //    
    static int i = 47;
    
}

public class StaticTest
{
    //  2) if we need a method that we can call even if no objects are created
    static int increment()
    {
        return Test.i++;
        
    }

    public static void main(String[] args)
    {

        Test test1 = new Test();
        Test test2 = new Test();
        //test1.i and test2.i have the same value of 47 since they refer to the same piece of memeory
        System.out.println("test1.i:" + test1.i + ";test2.i:" + test2.i); //47
        
        //another way, we can refer to it directly through the class name
        System.out.println("Test.i:" + ++Test.i); //48
        System.out.println("test1.i:" + test1.i + ";test2.i:" + test2.i); //48
        

        // an import use of static for methods is to allow you to call that method without creating an object
        StaticTest test3 = new StaticTest();
        System.out.println("test3.increment:" + test3.increment()); //48

        System.out.println("StaticTest.increment:" + StaticTest.increment()); //49
        
    }
        
}



