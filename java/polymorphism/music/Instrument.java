//Instrument.java:  muyun
//
package polymorphism.music;
class Instrument
{
    public void play(Note n)
    {
        System.out.println("Instrument.play()");
        
    }

    //new methods
    //these new classes work correctly with the old, unchanged tune() method.
//Even if tune() is in a separate file and new methods are added to the interface of instrument,
//tune() will still work correctly, even without recompiling it

    String what()
    {
        return "Instrument";
        
    }

    void adjust()
    {
        System.out.println("Adjusting Instrument");
        
    }

}


