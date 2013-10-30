//Wing.java
//
package polymorphism.music;

//Wind objects are instruments because they have the same interface
public class Wind extends Instrument
{
    //redefine interface method
    public void play(Note n)
    {
        System.out.println("Wind.play() " + n);
        
    }

    public String what()
    {
        return "Wind";
    }

    public void adjust()
    {
        System.out.println("Adjusting Wind");
        
    }

        
}

