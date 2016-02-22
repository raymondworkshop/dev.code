//PolyConstructors.java
//behavior of polymorphic methods inside constructors
//
//reference to polymorphism
//
package polymorphism;

class Glyph {
    
    void draw() {
        System.out.println("Glyph.draw()");
    }

    Glyph(){
        System.out.println("Glyph() before draw()");
        //for constructor, do as little as possible to set the object into a good state,
        // and if we can possibly avoid it, don't call any other methods in this class
        // or it will be overidden
        // of course,  the only safe methods to call inside a constructor are those that are final(private) in the base class,
        //because these cannot be overidden
        draw();  
        System.out.println("Glyph() after draw()");
    }
    
}

class RoundGlyph extends Glyph {
    private int radius = 1;
    RoundGlyph(int r){
        radius = r;
        System.out.println("RoundGlyph.RoundGlyph(), radius = " + radius);
    }
    //overidden,
    //when new RoundGlyph(5), this method is called
    void draw(){
        System.out.println("RoundGlyph.draw(), radius = " + radius);
    }
        
}

public class PolyConstructors {
    public static void main(String[] args){
        // the actual process of initialization:
        //1. the storage allocated for the object is initialized to binary zero before anything else happens
        
        //2. the base-class constructors Glyph() are called.
        // at this point, the overideden draw() method is called (before the RoundGlyph consructor),
        //  which discovers a radius value of zero, due to step 1.
        //
        //3. member initializers are called in the order of declaration
        //4. the body of the derived-class constructor is called
        new RoundGlyph(5);
    }
}

