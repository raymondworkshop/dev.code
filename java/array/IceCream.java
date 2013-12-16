//IceCream.java
//reference to the code in "Thinking in java"
//1. in c/c++, we can't return an array, only a pointer to an array;
//    - this becomes messy to control the lifetime of the array, which leads to memory leaks.
//   in java, we just return the array, we never worry about responsibility for that array;
//    - the array will be around as long as we need it, and the garbage collector will clean it up when we're done.
//
import java.util.Random;
import java.util.Arrays;

public class IceCream {
    private static Random rand = new Random(47); //seed
    static final String[] FLAVORS = {
        "Chocolate", "Cream", "Pie", "Fudge"
    };

    public static String[] flavorSet(int n){
        if(n > FLAVORS.length)
            throw new IllegalArgumentException("Set too big");
        
        String[] results = new String[n];
        boolean[] picked = new boolean[FLAVORS.length];
        for(int i = 0; i < n; i++){
            int t;
            //choose flavors randomly from the array FLAVORS and place them into results
            do
                t = rand.nextInt(FLAVORS.length);
            while(picked[t]);

            results[i] = FLAVORS[t]; 
            picked[t] = true;
        }

        //2. returning an array is jsut like returning any other object, it's a reference.
        // It's not important that the array was created within flavorSet(), or that the array was created anyplace else.
        //
        return results; //return the arrays, results is a reference to the array
    }

    public static void main(String[] args){
        for(int i = 0; i < 7; i++)
            System.out.println(Arrays.toString(flavorSet(3)));
    }
    
}

