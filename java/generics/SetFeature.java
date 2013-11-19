//SetFeature.java
//1. Collection is a sequence of individual elements with one or more rules applied to them
// List - hold the elements in the way that they were inserted
// Set  - cannot have duplicate elements
// Queue - produce the elements in the order determined by a queuing discipline
//
//2. the most common use for a Set is to test for membership
//lookup is the most important operation for a Set

//3.  HashSet uses the hashing function
//    TreeSet keeps elements sorted into a red-black tree data structure
//    LinkedHashSet also uses hashing for lookup speed, but appears to maintain elements in insertion order using a linked list
//
import java.util.Random;
import java.util.Set;
import java.util.HashSet;

public class SetFeature {
    public static void main(String[] args){
        //using the seed 47 can enerate the same number every time the nextInt() method is called
        Random rand = new Random(47); 
        Set<Integer> set1 = new HashSet<Integer>();

        for(int i = 0; i < 1000; i++)
            //nextInt() returns a pseudorandom, uniformly distributed int value between 0 and 10;
            //All 10 possible int values are produced with approximately equal probability
            intset.add(rand.nextInt(10));
        System.out.println(set1);

                
    }
}

