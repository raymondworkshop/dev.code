//Mocha.java
//
package designpattern.decoratorpattern;
//
//Mocha is a decorator, so we extend CondimentDecorator;
//CondimentDecorator extends Beverage.
public class Mocha extends CondimentDecorator {
    //instantiate Mocha with a reference to a Beverage using:
    // 1). an instance variable to hold the beverage we are wrapping
    Beverage beverage;
    // 2). a way to set this instance variable to the object we are wrapping
    public Mocha(Beverage beverage){
        this.beverage = beverage;
    }

    public String getDescription(){
        return beverage.getDescription() + ", Mocha"; // the beverage + each item decorating the beverage
    }

    public double cost(){
        return .20 + beverage.cost();
    }
}

