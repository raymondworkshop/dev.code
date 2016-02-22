//StoringAndRecoveringData.java
//
//1. A PrintWriter formats data so that it's readable by a human
//
package io;

import java.io.IOException;
//FileOutputStream is meant for writing streams of raw bytes such as image data;
//For writing streams of characters, consider using FileWriter
import java.io.FileOutputStream; 
//import java.io.FileWriter;
//
//create a new bufferred output stream to write data to the specified underlying output stream
import java.io.BufferedOutputStream;

//2. to output data for recovery by another stream, we use a DataOutputStream to write the data
// and a DataInputStream to recover the data;
//   If we use a DataOutputStream to write the data, then Java guarantees that we can accurately recover
// the data using a DataInputStream --- regardless of what different platforms write and read the data
import java.io.DataOutputStream;

import java.io.DataInputStream;
import java.io.BufferedInputStream;
import java.io.FileInputStream;


public class StoringAndRecoveringData {
    public static void main(String[] args) throws IOException {
        DataOutputStream out = new DataOutputStream(new BufferedOutputStream(new FileOutputStream("Data.txt")));

        out.writeDouble(3.14159); //The writeDouble() method stores the double number to the stream
        
        //3. UTF-8 is an encoding used to translate binary data into numbers,
        //   Unicode is a character set used to translate numbers into characters;
        //
        //4. When we are using a DataOutputStream, the only reliable way to write a String so that it can be recovered by a
        //DataInputStream is to use UTF-8 encoding, accomplished using writeUTF() and readUTF() .
        //
        //   Unicode creates a single character set that included every reasonable writing system on the planet;
        //   UTF-8 is the byte-oriented encoding form of unicode.
        //   UTF-8 is interpreted as a sequence of bytes, there is no endian problem as there is for encoding forms that use 16-bit or 32-bit code units.
        //   UTF-16 uses a single 16-bit code unit to encode the most common 63k characters.
        //
        //5. if we're working with ASCII or mostly ASCII characters (which occupy only seven bits), Unicode is a tremendous waste
        // of space and/or bandwidth, so UTF-8 encodes ASCII characters in a single byte, and non-ASCII characters in two or three bytes;
        //   UTF-8 is an ASCII extension
        //   
        out.writeUTF("That was pi");

        out.writeDouble(1.41413); 
        out.writeUTF("Square root of 2");
        
        out.close();

        DataInputStream in = new DataInputStream(new BufferedInputStream(new FileInputStream("Data.txt")));

        System.out.println(in.readDouble());
        
        //
        System.out.println(in.readUTF());
        System.out.println(in.readDouble()); //the complementary readDouble() method recovers it
        System.out.println(in.readUTF());
        
    }
    
}

