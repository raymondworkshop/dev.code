//InheritingExceptions.java
//error handling with exceptions
//1. the goals for exception handling in Java are to simplify the reation of large, reliable programs
// using less ocde than currently possible, and to do so with more confidence that your application doesn't
// have an unhandled error.
//
//2.  'exception' means the problem occurs, you might not know what to do with it, but you do know that you can't
// just continue on merrily;
//    Also, without exceptions, you must check for a particular error and deal with it at multiple places in your problem;
// With exceptions, you no longer need to check for errors at the point of the method call, since the exception will guarantee
// that someone catches it. You only need to handle the problem in one place, in the so-called exception handler.
//

//4. to create our own exception class, we must inherit from an existing exception class,
//preferably one that is close in meaning to our new exception; the most trivial way is to let the compiler create the default constructor.
class SimpleException extends Exception {}

class MyException extends Exception {
    public MyException() {}
    public MyException(String msg){
        super(msg); //call base-class version
    }
}

public class InheritingExceptions {
    public static void f() throws MyException {
        System.out.println("Throw MyException from f()");
        //3. by new an object representing your information and throwing it out of your current context;
        //exception handling is as a different kind of return mechanism;
        
        //After new an exception object, you give the resulting reference to throw.
        throw new MyException();
    }

    public static void g() throws MyException {
        System.out.println("Throwing MyException from g()");
        throw new MyException("Originated in g()");
    }

    public static void main(String[] args){
        //InheritingExceptions sed = new InheritingExceptions();
        try{ //code that might generate exceptions
            
            //we don't want a throw to exit the method, we can set up this special block within that method to capture the exception
            f();
            
        }catch(MyException e) { //the throw exception must end up someplace, the place is called exception handler; 
            //and there's one for every exception type you want to catch
            e.printStackTrace(System.out); // printStackTrace method let information goes to standard error stream
        }

        try{
            
            g();
            
        }catch(MyException e){
            e.printStackTrace(System.out);
        }
        
    }
        
}

