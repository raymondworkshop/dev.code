//ReverseLines9.java
//
package io;

import java.io.IOException;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.LinkedList;


public class ReverseLines9 {
    public static String read(String filename) throws IOException {
        //Reading input by lines:
        BufferedReader in = new BufferedReader(new FileReader(filename));
        String s;
        LinkedList<String> list = new LinkedList<String>();
        
        StringBuilder sb = new StringBuilder();

        while((s = in.readLine()) != null)
            list.add(s.toUpperCase()); // add each line to LinkedList
        while(list.peekLast() != null) // while there is a lase line
            sb.append(list.pollLast() + "\n");
        
        in.close();
        return sb.toString();
    }

    public static void main(String[] args) throws IOException {
        System.out.print(read("BufferedInputFile.java"));
    }
    
}

