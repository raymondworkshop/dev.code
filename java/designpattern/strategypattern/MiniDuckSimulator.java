//MiniDuckSimulator.java
//Type and compile the test class
package strategypattern;

public class MiniDuckSimulator {
    public static void main(String[] args){
        Duck mallard = new MallardDuck();
        //call MallardDuck's inherited performQuack() method, which then delegates to the object's QuackBehavior
        mallard.performQuack();
        mallard.performFly();
        
    }
    
}

