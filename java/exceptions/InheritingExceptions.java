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

class ScaryException extends Exception {}

public class InheritingExceptions {
    public static void doRisky(String test) throws ScaryException {  //the method doRisky() tells the word that it throws a SimpleException;
        System.out.println("start risky");
        //3. by new an object representing your information and throwing it out of your current context;
        //exception handling is as a different kind of return mechanism;
        if("yes".equals(test)){
            //After new an exception object, you give the resulting reference to throw.
            throw new ScaryException();
        }
        
        System.out.println("end risky");
        return;
    }

    public static void main(String[] args){
        String test = "yes";
        
        try{ //if try block succeeds, no exception
            //do risky thing;
            System.out.println("start try");
            
            doRisky(test);
            System.out.println("end try");
                        
        }catch(ScaryException se) { //if try block fails, an exception
            //try to recover;
            System.out.println("scary exception");
            
        }finally { // finally still run, doesn't matter try block fails or succeeds
            System.out.println("finally");
        }

        System.out.println("end of main");
    }
        
}

