//MuteQuack.java
//
package designpattern.strategypattern;

public class MuteQuack implements QuackBehavior {
    public void quack() {
        System.out.println("Silence");
    }
    
}

