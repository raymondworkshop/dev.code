//Beverage.java:
//1. Decorator pattern attaches additional responsibilities to an object dynamically;
// decorators provide a flexible alternative to subclassing for extending functionality
//
//2. When I inherit behavior by subclassing, that behavior is set statically at compile time;
//   all subclasses must inherit the same behavior.
//   If I can extend an object's behavior through composition, then i can do this dynamically at runtime
//
package designpattern.decoratorpattern;
//
public abstract class Beverage {
    String description = "Unknown Beverage";

    public String getDescription(){
        return description;
    }

    public abstract double cost();
    
}



