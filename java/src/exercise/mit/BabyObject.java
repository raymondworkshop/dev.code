package exercise.mit;

public class BabyObject {
     private String name;
     private boolean isMale;
     // static means that it can be directly invoked via the class
     private static int num = 0;
     
     private int servings =2; // used for the test
       
     BabyObject(){
         num += 1; // keep track of the number of babies have been made
     }
     
     
     BabyObject(String myname, boolean maleBaby){
          name = myname;
          isMale = maleBaby;
          
          num += 1;
     }
     
     void feed(int servings){ // servings in method-scope
         servings = servings + servings;
         System.out.println("feed: " + servings);
     }
     
     void thisfeed(int servings){ // this - 1)means "my object", not the local method scope 2). clarifies scope
         this.servings = this.servings + servings;
         System.out.println("feed: " + servings);
     }
     
     void poop(){
         
         //servings = 0;
         System.out.println("poop: " + servings);
     }
     
     String getName(){
         return name;
     }
    
     static void  doSomething(int x, int[] ys, BabyObject b){
         x = 99;
         ys[0] = 99;
         b.name = "99";
     }
     
    // == compares the references
    
    public static void main(String[] args){
        BabyObject mybaby = new BabyObject("davy", true);
        System.out.println(mybaby.getName());
        
        // using . flollows the reference to the object
        mybaby.name = "david";
        System.out.println(mybaby.getName());
        
        // reference
        int i = 0;
        int[] j = {0}; // string is the reference
        BabyObject k = new BabyObject("50", true);
        doSomething(i, j, k);
        System.out.println("i:" + i + " j:"+j[0] + " k:"+ k.getName()); //0, 99, 99
        
        // static
        BabyObject.num = 100;
        BabyObject b1 = new BabyObject();
        BabyObject b2 = new BabyObject();
        BabyObject.num = 2;
        System.out.println("b1:"+b1.num + " b2:"+b2.num);
        
        
        // test the this
        BabyObject b = new BabyObject();
        b.feed(1);
        b.poop();
        
        BabyObject thisb = new BabyObject();
        thisb.thisfeed(1);
        thisb.poop();
    }
    
}
