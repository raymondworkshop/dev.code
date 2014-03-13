//SimplePizzaFactory.java
// factories handle the details of object creation

//1. advantage: by encapsulating the pizza creating in one class,
//we now have only one place to make modifications when the implementation changes

//3. Defining a simple factory as a static method is a common technique and is often called a static factory;
// because we don't need to instantiate an object to make use of the create method.
// the disadvanage is that we can't subclass and change the behavior of the create method.
public class SimplePizzaFactory {
    //2. define a createPizza() method in the factory
    //this is the method all clients will use to instantiate new object
    public Pizza createPizza(String type) {
        Pizza pizza = null;

        if(type.equals("cheese")) {
            pizza = new CheesePizza();
        } else if (type.equals("pepperoni")) {
            pizza = new PepperoniPizza();
        } else if (type.equals("clam")) {
            pizza = new ClamPizza();
        } else if (type.equals("veggie")){
            pizza = new VeggiePizza();
        }

        return pizza;
    }
        
}

