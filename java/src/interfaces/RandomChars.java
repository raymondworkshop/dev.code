//RandomChars.java:
// adapte to an interface:
// 1. One of the most compelling reasons for interfaces is to allow multiple implementations for the same interface
//   1) in simple cases, we implement that interface and pass our object to the method
//
// 2.  A common use for interfaces is the Strategy design pattern.
//      1)we write a method that performs certain operations, and that method takes an interface that we also specify.
//      2)This means that "you can use my method with any object you like, as long as your object conforms to my interface", this makes
//        our method more flexible, general and resuable
//
package interfaces;

import java.util.Random;

// a class produces a sequence of chars
public class RandomChars {
    private static Random rand = new Random();
    public char next(){
        return (char)rand.nextInt(128);
    }

    public static void main(String[] args){
        RandomChars rc = new RandomChars();
        for(int i=0; i<10; i++)
            System.out.print(rc.next() + " ");
        System.out.println();
    }
    
}

