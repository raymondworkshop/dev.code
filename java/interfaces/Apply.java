//Apply.java
//
package interfaces;

import java.lang.Class;
import java.util.Arrays;


class Processor {
    public String name(){
        return getClass().getSimpleName();
        
    }

    Object process(Object input) {
        return input;
    }
    
}

class Upcase extends Processor {
    String process(Object input){
        return ((String) input).toUpperCase();
    }
    
}

class Downcase extends Processor {
    String process(Object input){
        return ((String)input).toLowerCase();
    }
}

class Splitter extends Processor {
    String process(Object input){
        return Arrays.toString( ((String)input).split("") );
    }
}

public class Apply {
    public static void process(Processor p, Object s){
        System.out.println("Using Processor " + p.name() );
        System.out.println(p.process(s));
    }

    public static String s = "Disagreement with beliefs";

    //Strategy design pattern - creatign a method that behaves differently depending on the argument object that you pass it,
    // the method contains the fixed part of the algorithm to be performed, and the Strategy contains the part that varies.
    
    //The processor object is the Strategy, which is the object that we pass in, and it contains code to be executed.
    //and we can see theree different Strategies applied to String s
    public static void main(String[] args){
        process(new Upcase(), s);
        process(new Downcase(), s);
        process(new Splitter(), s);
    }
}




