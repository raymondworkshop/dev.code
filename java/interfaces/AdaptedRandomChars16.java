//AdaptedRandomChars16.java: muyun
//Adapt this class so that it can be an input to a Scanner object.
//Implementing an interface to conform to a method
//
// 2.  A common use for interfaces is the Strategy design pattern.
//      1)we write a method that performs certain operations, and that method takes an interface that we also specify.
//      2)This means that "you can use my method with any object you like, as long as your object conforms to my interface", this makes
//        our method more flexible, general and resuable
//
package interfaces;
/* For example,
 * the constructor for the Java SE5 Scanner class takes a Readable interface,
 * the Readable interface is not an argument for any other method, it was created solely for Scanner.
 *
 * In this way, Scanner can be made to work with more types, if we create a new class and we want it to be usable with Scanner,
 *  we make it Readable.
*/
import java.util.Scanner;
import java.nio.*;

// The Readable interface only requires the implementation of a read() method.
//we can add an interface onto the existing class,
// which means that a method that takes an interface provides a way for any class to be adapted to work with that method

//we create a new class AdaptedRandomChars16 and we want it to be usable with Scanner, we make it Readable
public class AdaptedRandomChars16 extends RandomChars implements Readable {
    private int count;
    public AdaptedRandomChars16(int count){
        this.count = count;
    }
    // The Readable interface only requires the implementation of a read() method.
    public int read(CharBuffer cb){
        if(count-- == 0)
            return -1;
        String result = Character.toString(next()) + " ";
        cb.append(result);
        return result.length();
    }

    public static void main(String[] args){
        //Scanner can be made to work with more types
        Scanner s = new Scanner(new AdaptedRandomChars16(10));

        while(s.hasNext())
            System.out.println(s.next() + " ");
    }
}


