//Games19.java
//An interface is intended to be a gateway to multiple implementations.
// a typical way to produce objects that fit the interface is that Factory Method design pattern.
// Instead of calling a constructor directly,
//we can call a creation method on a factory method on a factory object
//which produces an implementation of the interface.
//
//in this way, our code is completely isolated from the implementation of the interface
//
package interfaces;

import java.util.Random;

//create a framework using Factory Methods that performs both coin tossing and dice tossing
interface Games {
    void play();
}

interface GamesFactory {
    Games getGames();
}

class CoinToss implements Games {
    Random rand = new  Random();
    public void play(){
        System.out.println("Toss Coin: ");
        switch(rand.nextInt(2)){
            case 0 :
                System.out.println("Heads");
                return;
            case 1 :
                System.out.println("Tails");
                return;
            default :
                System.out.println("OnEdge");
                return;
        }
        
    }
    
}

//Instead of calling a constructor directly,
// call a creation method on a factory object which produces an implementation of the interface
class CoinTossFactory implements GamesFactory {
    public Games getGames(){
        return new CoinToss();
    }
    
}

class DiceThrow implements Games {
    Random rand = new Random();
    public void play(){
        System.out.println("Throw Dice: " + (rand.nextInt(6) + 1));
    }
    
}

class DiceThrowFactory implements GamesFactory {
    public Games getGames(){
        return new DiceThrow();
    }
}

public class Games19 {
    public static void playGame(GamesFactory factory){
        Games g = factory.getGames();
        g.play();
    }

    public static void main(String[] args){
        playGame(new CoinTossFactory());
        playGame(new DiceThrowFactory());
    }
}


