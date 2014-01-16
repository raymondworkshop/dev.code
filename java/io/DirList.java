//DirList.java
//
//a compiled representation of a regular expression
import java.util.regex.Pattern; 
import java.io.File;
import java.io.FilenameFilter;
import java.util.Arrays;

/*
//Interface FilenameFilter in java.io
public interface FilenameFilter {
    boolean accept(File dir, String name);
}
*/

class DirFilter implements FilenameFilter {
    private Pattern pattern;
    public DirFilter(String regex){
        pattern = Pattern.compile(regex); //compile the given regular expression into a pattern
    }

    //Tests if a specified file should be included in a file list
    public boolean accept(File dir, String name){
        //matcher() creates a matcher that will match the given input against this pattern
        //matches() compiles the given regular expression and attempts to match the given input against it
        return pattern.matcher(name).matches();
    }
    
}

public class DirList {
    public static void main(String[] args){
        File path = new File(".");
        String[] list;
        if(args.length == 0)
            list = path.list(); //list() function returns an array of strings naming the files and directories
        else
            list = path.list(new DirFilter(args[0]));

        //using the Arrays.sort()
        Arrays.sort(list, String.CASE_INSENSITIVE_ORDER);
        
        for(String dirItem : list)
            System.out.println(dirItem);
        
    }
    
}
