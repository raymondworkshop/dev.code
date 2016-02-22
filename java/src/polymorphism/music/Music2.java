//Music.java
//Inheritance and upcasting

package polymorphism.music;
/*
//these new classes work correctly with the old, unchanged tune() method.
//Even if tune() is in a separate file and new methods are added to the interface of instrument,
//tune() will still work correctly, even without recompiling it
class Instrument
{
    void play(Note n)
    {
        System.out.println("Instrument.play()" + n);
    }
    //new methods
    String what()
    {
        return "Instrument";
        
    }

    void adjust()
    {
        System.out.println("Adjusting Instrument");
        
    }
        
}
*/

/*    
class Wind extends Instrument
    void play(Note n)
    {
        System.out.println("Wind.play()" + n);
    }

    String what()
    {
        return "Wind";
        
    }

    void adjust()
    {
        System.out.println("Adjusting Wind");
        
    }
        
}
*/
class Brass extends Wind
{
   public void play(Note n)
    {
        System.out.println("Brass.play() " + n);
        
    }

    public void adjust()
    {
        System.out.println("Adjusting Brass");
        
    }
            
}


public class Music2
{
    //Don't care about type, so new types added to the system still work right
    //tune() method is blissfully ignorant of all the code changes (like the methods what() and adjust()),
    // and yet it works correctly. This is exactly what polymorphism is supposed to provide.
    //Changes in your code don't cause damage to parts of the program that should not be affected
    public static void tune(Instrument i)
    {
        i.play(Note.MIDDLE_C);
    }

    public static void tuneAll(Instrument[] e)
    {
        for(Instrument i : e)
            tune(i);
    }
    

    public static void main(String[] args)
    {
         //3) extensibility
        //so we can add as many new types as we want to the syatem without changing the tune() method, most or all of your methods
        // will follow the model of tune() and communicate only with the base-class interface
        
        // such a program is extensible because we can add new functionality by inheriting new data types from the common base class;
        // the methods that manipulate the base-class interface will not need to be changed at all to accommodate the new classes
        
        Instrument[] orchestra = { //upcasting
            new Wind(),
            new Brass()
        };

        tuneAll(orchestra);
        
        }
        
}


