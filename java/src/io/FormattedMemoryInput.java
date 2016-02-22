//FormattedMemoryInput.java
//use a DataInputStream, which is a byteoriented I/O class rather than char-oriented
//
//class DataInputStream extends FilterInputStream implements DataInput
package io;

import java.io.DataInputStream;
//class ByteArrayInputStream extends InputStream;
//A ByteArrayInputStream contains an internal buffer that contains bytes that may be read from the stream
import java.io.ByteArrayInputStream; 
import java.io.IOException;
import java.io.EOFException;

public class FormattedMemoryInput {
    public static void main(String[] args) throws IOException {
        try {
            //ByteArrayInputStream(byte[] buf) must be given an array of bytes, so String has a getBytes() method
            DataInputStream in = new DataInputStream(new ByteArrayInputStream(BufferedInputFile.read("FormattedMemoryInput.java").getBytes()));
            //if we read the characters from a DataInputStream one byte at a time using readByte(), any byte value is a legimate result,
            //so the return value cannot be used to detect the end of input.
            //Instead, we can use the available() method to find out how many more characters are available
            while(in.available() != 0 )
                System.out.print((char)in.readByte());
        }catch(EOFException e) {
            System.err.println("End of stream");
        }
                
    }
    
}

