//Adventure.java:
package interfaces;

//Multiple inheritance -- An x is an A and a B and a C
//in java, you can inherit from only one non-interface, all the rest refers to the base interfaces
//
interface CanFight {
    void fight();
}

interface CanSwim {
    void swim();
}

interface CanFly {
    void fly();
}

class ActionCharacter {
    public void fight(){
        System.out.println("fight function");
    }
}

//1. inherit from class ActionCharacter firstly, and interfaces CanFight, CanSwim, CanFly
class Hero extends ActionCharacter implements CanFight, CanSwim, CanFly {
    public void swim(){}
    public void fly() {}
    //Hero does not explicitly provide a definition for fight(),
    // the definition comes along with ActionCharacter
    
}

public class Adventure {
    public static void t(CanFight x){
        x.fight();
    }

    public static void u(CanSwim x){
        x.swim();
    }

    public static void v(CanFly x){
        x.fly();
    }

    public static void w(ActionCharacter x){
        x.fight();
    }

    public static void main(String[] args){
        Hero h = new Hero();

        //2. the core reasons for using interfaces:
        //Upcast to more than one base type, interface provides the flexibility
        t(h); //Upcast to interface CanFight; 
        u(h);
        v(h);
        w(h);

        //3. the 2nd reason for using interfaces is the same as using an abstract base class
        //   prevent the client programmer from making an object of this class
        //   and to establish that it is only an interface
        
    }
    
}








