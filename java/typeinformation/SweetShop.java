//SweetShop.java
//reference to "Thinking in java"
//1. Runtime type information(RTTI) allows us to discover and use type information while a program is running;
//   the Class object is used to create all of the regular objects of your class, Java performs its RTTI using the Class object.
//   like Candy.class, Cookie.class, Gum.class and SweetShop.class
//
//2. All classes are loaded into the JVM dynamically, upon the first use of a class;
//   This happens when the program makes the first reference to a static member of that class.
//
//3. a java program isn't completely loaded before it begins, but instead pieces of it are loaded when necessary.
//

//4. each of the classes Candy, Gum and Cookie has a static clause that is executed as the class is loaded for the first time.
class Candy {
    static {  //the static initialization is performed upon class loading
        System.out.println("Loading Candy");
    }
}

class Gum {
    static {
        System.out.println("Loading Gum");
    }
}

class Cookie {
    static {
        System.out.println("Loading Cookie");
    }
}

public class SweetShop {
    public static void main(String[] args){
        System.out.println("inside main");
        new Candy();  //Loading Candy
        System.out.println("After creating Candy");

        try{
            //anytime we want to use type information at run time, we must first get a reference to the appropriate Class object
            Class.forName("Gum"); // get a reference to the Class object; Loading Gum
            
        } catch(ClassNotFoundException e){
            System.out.println("Couldn't find Gum");
        }

        System.out.println("After Class.forName(\"Gum\") ");
        new Cookie();  //Loading Cookie
        System.out.println("After creating Cookie");
    }
    
}

