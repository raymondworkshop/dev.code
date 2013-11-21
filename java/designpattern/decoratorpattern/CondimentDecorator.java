//CondimentDecorator.java
// Decorator pattern
//
// this is an abstract decorator;
//
// firstly, we need to be interchangeable with a Beverage, so we extend the Beverage class;
// also, we're also going to require that the condiment decorators all reimplement the getDescription() method
//
package decoratorpattern;
//
public abstract class CondimentDecorator extends Beverage {
    public abstract String getDescription();
}

