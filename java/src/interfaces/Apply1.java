//Apply.java
//
package interfaces;

public class Apply1 {
    public static void process(Processor p, Object s){
        System.out.println("Using Processor " + p.name());
        System.out.println(p.process(s));
    }
    
}

