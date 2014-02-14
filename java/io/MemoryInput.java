//MemoryInput.java
//Input from memory
//
// class StringReader extends Reader
import java.io.StringReader; 
import java.io.IOException;

public class MemoryInput {
    public static void main(String[] args) throws IOException {
        StringReader in = new StringReader(BufferedInputFile.read("MemoryInput.java"));
        
        int c;
        //read() reads a single character, overrides the read in class Reader
        //read() returns the next character as an int, or -1 if the end of the stream has been reached
        while((c = in.read()) != -1) //
            System.out.print((char)c); //cast to a char to print properly
        
    }
    
}

