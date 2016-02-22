//UseCaseTracker.java
// an annotation processor that reads the annotated PasswordUtils class and uses reflection to look for @UseCase tags
//
// Java SE5 provides extenstions to the reflection API to help you create the tools
//
package annotations;

//reflect can descrie code which is able to inspect other code in the same system
import java.lang.reflect.*; 
import java.util.*;

public class UseCaseTracker {
    public static void trackUseCases(List<Integer> useCases, Class<?> cl) {
        for(Method m : cl.getDeclaredMethods()) {
            UseCase uc = m.getAnnotation(UseCase.class); // the method returns the annotation object of the specified type, "UseCase"
            if(uc != null){
                System.out.println("Found Use Case:" + uc.id() + " " + uc.description());
                useCases.remove(new Integer(uc.id()));
            }
        }

        for(int i : useCases){
            System.out.println("Warning: Missing use case-" + i);
        }
    }

    public static void main(String[] args){
        List<Integer> useCases = new ArrayList<Integer>();
        Collections.addAll(useCases, 47, 48, 49, 50);
        trackUseCases(useCases, PasswordUtils.class);

    }
        
}

