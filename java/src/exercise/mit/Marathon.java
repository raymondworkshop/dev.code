package exercise.mit;
/*
 * coding exercise
 * */

public class Marathon {
    public static int getMinIndex(int[] values){
        int minValue = Integer.MAX_VALUE;
        int minIndex = -1;
        
        for(int i = 0; i<values.length; i++){
            if(values[i] < minValue){
                minValue = values[i];
                minIndex = i;
            }
        }
        
        return minIndex;
    }
    
    
    public static int getSecondMinIndex(int[] values){
        int secondIdx = -1;
        int minIdx = getMinIndex(values);
        
        int value = Integer.MAX_VALUE;
        for(int i = 0; i<values.length; i++){
            if(minIdx == i){
                continue;
            }
            
            if(values[i] < value){
                value = values[i];
                secondIdx = i;
            }
        }
        
        return secondIdx;
    }
    
    public static void main(String[] args){
        String[] names = {
                "Elena", "Thomas", "Hamilton", "Suzie", "Phil", "Matt", "Alex",
                "Emma", "John", "James", "Jane", "Emily", "Daniel", "Neda",
                "Aaron", "Kate"
                };
        
        int[] times = {
                341, 273, 278, 329, 445, 402, 388, 275, 243, 334, 412, 393, 299,
                343, 317, 265
                };
        
        int idx = getMinIndex(times);
        System.out.println("The best performer is :" + names[idx]);
        
        int secondIdx = getSecondMinIndex(times);
        System.out.println("The second-best perormer is : " + names[secondIdx]);
        
        /*
        // find the largest and the second largest ones
        int time = 0;
        int index = 0;
        for(int i = 0; i < times.length; i++){
            //int time = times[0];
            if (time <= times[i]) {
                time = times[i];
                index = i;
            } else {
                continue;
            }
        }
        
        // print the name of the largest
        System.out.println("The best performer is : " + names[index]);
        
        //
        int secondTime = 0;
        int secondIndex = 0;
        for(int i = 0; i < times.length; i++ ){
            if((secondTime <= times[i]) && (time != times[i])){
                secondTime = times[i]; 
                secondIndex = i;
            } else {
                continue;
            }
        }
        
        //
        System.out.println("The second-best performer is : " + names[secondIndex]);
        */
    }

}
