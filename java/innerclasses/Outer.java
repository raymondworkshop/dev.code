//Outer.java
//inner class
class  Out {
    class Inner1 {
        Inner1(){ System.out.println("Out.Inner()"); }
    }
}

public class Outer {
    //a private String field
    private String s;

    //
    void f(){ System.out.println("Outer.f()"); }
    
    //an inner class
    class Inner {
        Inner (){ System.out.println("Inner()"); }
        //Inner class can access field s
        public String toString(){ return s; }

        public Outer outer(){
            return Outer.this;
            //A plain "this" would be Inner's "this"
        }
    }

    //return an object of type inner
    Inner makeInner(){
        return new Inner();
    }

    Outer(String s){
        System.out.println("Outer() with s");
        this.s = s;
    }
    Outer(){
        System.out.println("Outer()");
    }
    
    public static void main(String[] args){
        Outer o = new Outer("Hello,World!");
        Inner i = o.makeInner();
        System.out.println(i.toString());

        Outer ot = new Outer();
        //make an object of the inner class
        Outer.Inner oti = ot.makeInner();
        oti.outer().f();

        //make an instance of the inner class in
        Out o1 = new Out();
        //then create inner class object
        Out.Inner1 oi = o1.new Inner1();
    }
        
}

