//MallardDuck.java
package designpattern.strategypattern;

public class MallardDuck extends Duck {
    //A MallarDuck uses the Quack class to handle its quack,
    //so when performQuack is called, the responsibility for the quack is delegated to the Quack object and we get a real quack
    //
    //MallardDuck inherits the quack behavior and flyBehavior instance variables from class Duck
    public MallardDuck(){
        quackBehavior = new Quack();
        flyBehavior = new FlyWithWings();
    }

    public void display(){
        System.out.println("I'm a real Mallard duck");
    }
        
}

