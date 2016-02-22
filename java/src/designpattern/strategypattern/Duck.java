//Duck.java
//1. The strategy pattern defines a family of algorithms (different ways of quacking or flying),
//   encapsulates each one, and makes them interchangeable.
//
//   Strategy lets the algorithm vary independently from clients that use it.
//
//2. Design principle
//     1): Identify the aspects of your application that vary and separate them from what stays the same
//
package designpattern.strategypattern;

public abstract class Duck {
    //3. fly() and quack() are the parts of the Duck class that vary across ducks.
    //   To separate these behaviors from the Duck class, pull both methods out of the Duck class and
    //   create a new set of classes to represent each behavior.
    //
    //so, declare two reference variables for the behavior interface types.
    FlyBehavior flyBehavior;
    QuackBehavior quackBehavior;
    
    public void performFly(){
        flyBehavior.fly();  //Duck object delegates that behavior to the object referenced by flyBehavior
    }

    public void performQuack(){
        quackBehavior.quack();
    }

    public void swim(){
        System.out.println("All ducks float, even decoys!");
    }

    public abstract void display();
        
}

