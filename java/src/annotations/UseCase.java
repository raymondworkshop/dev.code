//UseCase.java
//1. Annotations, a form of metadata, provide a formalized way to add information to your code so that we can easily use that data at some later point
//
//Annotations are true language constructs and hence are structured, and are type-checked at compile time .
//Keeping all the information in the actual source code and not in comments makes the code neater and easier to maintain .
//
package annotations;

import java.lang.annotation.*;

@Target(ElementType.METHOD)   //@Target: where this annotation can be applied.
@Retention(RetentionPolicy.RUNTIME) //@Retention: how long the annotation information is kept

//to add this same metadata with an annotation, you must first define the annotation type
public @interface UseCase {
    public int id();
    public String description() default "no description";
}


