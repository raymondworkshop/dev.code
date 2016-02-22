//Parcel8.java
//chapter innerclass in thinking in java
package innerclasses;

public class Parcel8 {
    public Wrapping wrapping(int x){
        //1. create an object of an anonymous class that's inherited from Wrapping
        return new Wrapping(x){ //pass argument to the base-class constructor
            public int value(){
                return super.value() * 47;
            }
        }; //semicolon marks the end of the expression that contains the anonymous class
    }
    
    /*
    class MyWrapping extends Wrapping {
      private int i;
      public MyWrapping(int x){
          i = x;
      }
      public int value (){
          return i * 47;
      }
    }

    public MyWrapping mywrapping(){
        return new MyWrapping();
    }
    */

    //2.implement an interface, only implement one interface
    public Destination destination(final String dest){ //argument must be final to use inside anonymous inner class
        return new Destination(){
            private String label = dest;
            public String readLabel(){
                return label;
            }
        };
    }

    //3. using "instance initialization" to perform construction on an anonymous inner class 
    public Destination destination(final String dest, final float price){
        return new Destination(){
            private int cost;
            //instance initialization for each object
            //in effect, an instance initializer is the constructor for an anonymous inner class
            //it's limited, we can't overload instance initializers
            {
                cost = Math.round(price);
                if(cost > 100)
                    System.out.println("Over budget!");
            }
            private String label = dest;
            public String readLabel(){
                return label;
            }
        };
            
    }
    
    public static void main(String[] args){
        Parcel8 p = new Parcel8();
        
        Wrapping w = p.wrapping(10);
        System.out.println(Integer.toString(w.value())); //470

        Destination d = p.destination("Tasmania");
        System.out.println(d.readLabel());

        Destination d1 = p.destination("Tasmania", 101.395F);
        System.out.println(d1.readLabel());
        
    }
}

