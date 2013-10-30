//Music.java
//Inheritance and upcasting

package polymorphism.music;

public class Music
{
    public static void tune(Instrument i)
    {
        //
        i.play(Note.MIDDLE_C);
        
    }

    public static void main(String[] args)
    {
        Wind flute = new Wind();
        //1) upcasting is safe because you are going from a more specific type to a more general type;
        // the only thing that can occur to the class interface during the upcast is that it can lose methods, not gain them
        tune(flute); //upcasting from Wind to Instrument may narrow the interface

        //2) all method binding in java happens polymorphically via late binding;
        //unless the method is static or final (private methods are implicitly final), this means that you don't need to make any
        //decisions about whether late binding will occur, it happens automatically, it effectively turns off dynamic binding

        //so talking the base class and know that all the drived-class cases will work correctly using the same code via late binding

    }
        
}


