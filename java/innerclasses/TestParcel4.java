//Parcel4.java:
//Inner classes and upcasting
//reference to chapter Inner classes from Thinking in class
//
//Compiled as >javac Contents.java Destination.java TestParcel4.java
//
class Parcel4 {
    //non-inner classes cannot be made private or protected.
    //private - nothing but Parcel4 can access it
    private class PContents implements Contents {
        private int i = 11;
        public void value(){
            System.out.println(Integer.toString(i));
        }
    }

    //protected - nothing but Parcel4 and the inheritors of Parcel4 can access PDestination
    protected class PDestination implements Destination {
        private String label;
        private PDestination (String whereTo){
            label = whereTo;
        }

        public void readLabel(){
            System.out.println(label);
        }
    }

    public Destination destination(String s){
        return new PDestination(s);
    }

    public Contents contents(){
        return new PContents();
    }

    //1) the private inner class provides a way
    //for the class designer to completely prevent any type-coding dependencies and
    // and to completely hide details about implementation .
    //2) extension of an interface is useless from the client programmer's perspective
    // since the client programmer cannot access any additional methods that aren't part of the public interface

    //3) this also provides an opportunity for the java compiler to generate more efficient code
    
    //because of the private and protected,
    //in client programmer can't access the name;
}

public class TestParcel4 {
        public static void main(String[] args){
            //4)the inner class Parcel4 - implementation of the interface - can be unseen and unaviable,
            //This is convenient for hiding the implementation;
            //All the clients get back is a reference to the base class or the interface.
            Parcel4 p = new Parcel4();
            Contents c = p.contents();
            c.value();
            
            Destination d = p.destination("Tasmania");
            d.readLabel();

            //client can't access private class
            /*
            Parcel4.PContents pc = p.new PContents();
            pc.value();
            */
        }
}

