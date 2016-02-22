//OSExecute.java
//Run an operating system command and send the output to the console
//
//import java.io.*;
//this class is used to create operating system processes
package io;

import java.lang.ProcessBuilder;
import java.io.BufferedReader;
//an InputStreamReader is a bridge from byte streams to character streams
//It reads bytes and decodes them into characters using a specified charset.
import java.io.InputStreamReader;


public class OSExecute {
    public static void command(String command){
        boolean err = false;
        
        try {
            //the start() method creates a new Process instance with those attributes
            Process process = new ProcessBuilder(command.split(" ")).start();

            //to capture the standard output stream from the program as it executes, you call getInputStream();
            //This is because an InputStream is something we can read from
            BufferedReader results = new BufferedReader(new InputStreamReader(process.getInputStream()));

            String s;
            while((s = results.readLine()) != null)
                System.out.println(s);

            BufferedReader errors = new BufferedReader(new InputStreamReader(process.getErrorStream()));
            //Report errors and return nonzero value to calling process if there are problems
            while((s = errors.readLine()) != null){
                System.err.println(s);
                err = true;
            }
            
        } catch (Exception e) {
            //
            if(!command.startsWith(""))
                command.();
            else
                throw new RuntimeException(e);
            
        }

        if(err)
            throw new OSExecuteException("Errors executing " + command);
                        
    }
    
}

