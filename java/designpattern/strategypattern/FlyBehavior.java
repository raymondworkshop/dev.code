//FlyBehavior.java
package strategypattern;

// compile the FlyBehavior interface
//
// 4. With this design, other types of objects can reuse our fly and quack behaviors
//        because these behaviors are no longer hidden away in our Duck classes.
//
//    And we can add new behaviors without modifying any of the Duck classes that use flying behaviors
public interface FlyBehavior {
    public void fly();
}

