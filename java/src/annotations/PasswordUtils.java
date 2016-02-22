//PasswordUtils.java
// a class with three methods annotated as use cases
//
package annotations;

//In java, import is simply used by the compiler to let you name your classes by their unqualified name
import java.util.*;

public class PasswordUtils {
    //The values of the annotation elements are expressed as name-value pairs in parentheses after the @UseCase declaration
    @UseCase(id = 47, description = "Passwords must contain at least one numeric")
    public boolean validatePassword(String password) {
        return (password.matches("\\w*\\d\\w*"));
    }

    @UseCase(id = 48)
    public String encryptPassword(String password) {
        return new StringBuilder(password).reverse().toString();
    }

    @UseCase(id = 49, description = "New passwords can't equal previously used ones")
    public boolean checkForNewPassword(List<String> prevPasswords, String password) {
        return !prevPasswords.contains(password);
    }
    
}

