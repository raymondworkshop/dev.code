//StarbuzzCoffee.java:
//instantiate the beverage and wrap it with all its condiments decorators
//
//
package decoratorpattern;

//
public class StarbuzzCoffee {
    public static void main(String[] args){
        //order up an espresso, no condiments
        Beverage beverage = new Espresso();
        System.out.println(beverage.getDescription() + " $" + beverage.cost());

        //
        Beverage beverage2 = new HouseBlend(); //make a HouseBlend object
        beverage2 = new Mocha(beverage2); //wrap it with a Mocha
        beverage2 = new Mocha(beverage2); //wrap it in a second Mocha
        beverage2 = new Whip(beverage2);  //wrap it in a Whip

        System.out.println(beverage2.getDescription() + " $" + beverage2.cost()); //give us a HouseBlend with Mocha, Mocha and Whip
    }
    
}

