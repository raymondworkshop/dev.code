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
    ////should be final, which is required by the anonymous inner class so that it can use an object from outside its scope
    public static FilenameFilter filter(final String regex){ 
        //creation of anonymous inner class:
        return new FilenameFilter() {
            private Pattern pattern = Pattern.compile(regex);
            public boolean accept(File dir, String name){
                return pattern.matcher(name).matches();
            }
        }; // end of anonymous inner class
                    
    }
    
    public static void main(String[] args){
        File path = new File(".");
        String[] list;
        //1. Strategy design pattern, because list() implements basic functionality,
        //and you provide the Strategy in the form of a FilenameFilter in order to complete the algorithm necessary for list() to provide its service.
        //
        //2. Because list() takes a FilenameFilter object as its argument, it means that you can pass an object of any class that implements FilenameFilter
        //to choose how the list() method will behave.
        //
        //3. the list() method is calling accept() for each of the file names in the directory object to see which one should be included;
        //   this is indicated by the boolean result returned by accept() .
        //TODO: why does the list() call accept()?
        if(args.length == 0)
            list = path.list(); 
        else
            //list = path.list(new DirFilter(args[0]));//java.io.File.list(FilenameFilter filter) returns an array of strings naming the files and directories
            list = path.list(filter(args[0]));
        
        //using the Arrays.sort()
        Arrays.sort(list, String.CASE_INSENSITIVE_ORDER);
        
        for(String dirItem : list)
            System.out.println(dirItem);

    }
    
}
