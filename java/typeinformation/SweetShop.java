//SweetShop.java
//reference to "Thinking in java"
//1. Runtime type information(RTTI) allows us to discover and use type information while a program is running;
//   It frees you from the constraint of doing type-oriented things only at compile time, and can enable some very powerful programs.
//
//   Java allows us to discover information about objects and classes at run time.
//     - RTTI, all the types available at compile time; which means that at run time, the type of an object is identified.
//     - reflection mechanism, discover and use class information solely at run time.
//
//2. Java performs its RTTI using the Class object.
//     - through a special kind of object called the Class object, the type information of RTTI is represented at run time.
//     - the Class object is used to create all of the regular objects of the type, 
//         like Candy.class, Cookie.class, Gum.class and SweetShop.class.
//
//     - JVM uses a subsystem called a class loader to make an object of that class
//
//     - All classes are loaded into the JVM dynamically, upon the first use of a class;
//        This happens when the program makes the first reference to a static member of that class.
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
    static final int staticFinal = 47;
    static int staticNonFinal = 74;
    static {
        System.out.println("Loading Cookie");
    }
}

public class SweetShop {
    public static void main(String[] args){
        System.out.println("inside main");
        new Candy();  //constructor is also a static method of a class; Loading Candy
        System.out.println("After creating Candy");

        try{
            //5. anytime we want to use type information at run time, we must first get a reference to the appropriate Class object
            Class.forName("Gum"); // get a reference to the Class object; Loading Gum
            
        } catch(ClassNotFoundException e){
            System.out.println("Couldn't find Gum");
        }
        
        System.out.println("After Class.forName(\"Gum\") ");

        //6. Another way to produce the reference to the Class object: the class literal
        //   - the is simpler, safer (echecked at compile time, thus needn't the try block), more efficient (eliminate the forName() method call);
        //   - three steps in preparing a class for use
        //    -- loading: the class loader finds the bytecodes and creates a Class object from those bytecodes;
        //    -- linking: verify the bytecodes, allocates storage for static fields, and resolves all references to other classes made by this class;
        //    -- initialization: initialize the superclass, execute static initializers and static initialization blocks
        //
        Class cookie = Cookie.class; //using the .class syntax to get a reference to the class doesn't cause initialization.
        
        //  Initialization is delayed until the first reference to a static method (the constructor is implicitly static) or to a non-constant static field
        //
        //7. If a static final value is a "compile-time constant", like Cookie.staticFinal, that value can be read without causing the Initalbe class to be initialized.
        System.out.println(Cookie.staticFinal); // does not trigger initialization
        
        //8. If a static field is not final, accessing it always requires linking (to allocate storage for the field) and initialization (to initialize that storage)
        // before it can be read,
        System.out.println(Cookie.staticNonFinal); //loading Cookie, does trigger initialization
                
    }
    
}
