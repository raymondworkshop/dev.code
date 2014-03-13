//BasicFileOutput.java
//
// public class BufferedReader extends Reader
//reads text from a character-input stream, buffering characters so as to provide for the efficient reading of characters,arrays,and lines
import java.io.BufferedReader;
//public class StringReader extends Reader
import java.io.StringReader; // a character stream whose source is a string

//public class PrintWriter extends Writer
//prints formatted representations of objects to a text-output stream
import java.io.PrintWriter;
//java.lang.Object
//     java.io.Writer
//          java.io.OutputStreamWriter
//               java.io.FileWriter
import java.io.FileWriter; // A FileWriter object writes data to a file; buffer the output by wrapping it in a BufferedWriter

//public class BufferedWriter extends Writer
// write text to a character-output stream, buffering characters so as to provide for the efficient writing of single characters, arrays, and strings
import java.io.BufferedWriter;
import java.io.IOException;

public class BasicFileOutput {
    static String file = "BasicFileOutput.out";
    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new StringReader(BufferedInputFile.read("BasicFileOutput.java")));

        PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(file)));

        int lineCount = 1;
        String s;
        while((s = in.readLine()) != null)
            out.println(lineCount++ + ": " + s);

        //if we don't call close() for all our output files, the buffers might not get flushed
        out.close();
        
        //show the stored file:
        System.out.println(BufferedInputFile.read(file));
    }
}

