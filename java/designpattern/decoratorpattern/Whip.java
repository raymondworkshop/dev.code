//Whip.java
//
package decoratorpattern;
//
//Whip is a decorator,
public class Whip extends CondimentDecorator {
    //instantiate Whip with a reference to a Mocha
    Beverage beverage;
    public Whip(Beverage beverage){
        this.beverage = beverage;
    }

    public String getDescription(){
        return beverage.getDescription() + ", Whip";
    }

    public double cost(){
        return 0.10 + beverage.cost();
    }
    
}

