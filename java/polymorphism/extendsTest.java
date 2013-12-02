//extendsTest.java
//
class Animal {
    int x;
    
    public void printIt1(){
        System.out.println("method 1 in super class Animal");
    }

    //2. static means that particular field or method is not tied to any particular object instance of the class;
    //even if you've never created an object of that class, you can call a static method or access a static field;
    // with ordinary, non-static fields and methods, you must create an object and use the object to access the field or method
    public static void printIt2(){
        System.out.println("method 2 in super class Animal");
    }
    
}

class Dog extends Animal {
    public void printIt1(){ //override
        super.printIt1();  // print "method in super class Animal"
        
        System.out.println("method 1 in sub class Dog");
    }

    public static void printIt2(){
        System.out.println("method 2 in sub class Dog");
    }

    public static void printIt3(){
        System.out.println("method 3 in sub class Dog");
    }
        
}

public class extendsTest {
    public static void main(String[] args){
        //1. dynamic method dispatch: the reference of type Animal to type Dog;
        // By doing this, we are able to call the mehtods that are defined in class Animal only.
        Animal a = new Dog();
        
        // Java waits till the runntime of the program and checks which object the reference is pointing to
        a.printIt1(); // print "method in sub class Dog"

        //2. static
        a.printIt2();  // print "method in super class Animal"

        //3. cast Object
        // a now only can call the methods that are defined in class Animal;
        //In order to call the methods that are defined by class Dog,
        // we need to cast the reference
        Dog d = (Dog)a;
        // 
        d.printIt3(); // print "method 3 in sub class Dog"
        
    }
    
}


