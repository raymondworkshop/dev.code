//StringProcessor.java
//interface:
//  1) an interface provides only a form, but no implementation;
//  2) interface is used to establish a 'protocol' between classes;
//  3) an interface is more than an abstract class taken to  the extreme,
//     since it allows us to perform a variation of 'multiple inheritance' by creating a class
//     that can be upcast to more than one base type

package interfaces;

import java.lang.Class;
import java.util.Arrays;

//1. the first way we can reuse code is if we can write the classes to conform to the interface

//if we want to prevent any instances of that class, we might make a class abstract.
//here, because we have the abstract method process, so the class StringProcessor is abstract class
public abstract class StringProcessor implements Processor1 {
    public String name(){
        return getClass().getSimpleName();
    }
    //if a class contains one or more abstract methods, the class itself must be qualified as abstract
    public abstract String process(Object input);
    
    public static String s = "Disagreement with beliefs";

    public static void main(String[] args){
        Apply1.process(new Upcase(), s);
        Apply1.process(new Downcase(), s);
        Apply1.process(new Splitter(), s);
    }
}

class Upcase extends StringProcessor {
    public String process(Object input){
        return ((String) input).toUpperCase();
    }
    
}

class Downcase extends StringProcessor {
    public String process(Object input){
        return ((String)input).toLowerCase();
    }
}

class Splitter extends StringProcessor {
    public String process(Object input){
        return Arrays.toString( ((String)input).split("") );
    }
}






