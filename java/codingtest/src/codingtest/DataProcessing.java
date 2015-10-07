package codingtest;

import java.util.*;
import java.io.BufferedReader;
import java.io.FileReader;

//import java.util.regex.Matcher;
//import java.util.regex.Pattern;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.BufferedWriter;

/**
 *  data cleaning, 
 *  
 *  Unigram Model and TF-IDF method are used here
 *
 */

public class DataProcessing {
	//
	//public int l; //num of training data
	//public int n; // num of features
	
	//public int[] y; // the target values
	
	//public HashMap<String, Integer> tf;  //
	public LinkedHashMap<String, Integer> idf; //
	public LinkedHashMap<String, Double> tf_idf; //
	public ArrayList<LinkedHashMap<String, Double>> lines ;  //  arraylist of hashmap
	//
	public DataProcessing(){
		 //l = 0;
		 //n = 0;
		 
		 //tf = new HashMap<String, Integer>(); // term_frequency 
		 idf = new LinkedHashMap<String, Integer>();  //
		 tf_idf = new LinkedHashMap<String, Double>(); //
		 lines = new ArrayList<LinkedHashMap<String, Double>>();
		 
	}
	
	//
	public void loaddata(String filename, String path) throws IOException{
		String line;
		
	    File file = new File(path);
	    FileWriter fw = new FileWriter(file.getAbsoluteFile());
	    BufferedWriter output = new BufferedWriter(fw);
	    
		//ArrayList<Integer> lines = new ArrayList<Integer>();
		
		//int N = 0; // the line number
		
		try{	

		   BufferedReader in = new BufferedReader(new FileReader(filename));
		   for (line = in.readLine(); line != null; line = in.readLine()) {
			   System.out.println(line);
			   
			   //String[] elems = line.split("");
			  
			   //data cleaning
			   processword(line);
			}
		   
		   // display the 
		   int N = lines.size();
		   for(int i = 0; i<N; i++){
			   LinkedHashMap<String, Double> norm_tf_line = lines.get(i);
			   
			   String str = " ";
			   //String str = "-1 "; //the input
			   
			   // each tf in each line/document
			   int feature = 1;
			   for(String word: norm_tf_line.keySet()){ 
				   //System.out.println(word + " - tf : " + norm_tf_line.get(word) );
				   //if(idf.containsKey(word)){
					   // idf(t)
					   double idf_val = Math.log10( N / (double)idf.get(word)) ;
					   //tf_idf = tf * idf
					   double tf_idf_val = norm_tf_line.get(word) * idf_val;
					   tf_idf.put(word, tf_idf_val);
					   
					   //write file in the training format
					   str += feature + ":" + tf_idf_val + " ";
					   
				   //}
					   feature += 1;
				  
			   } // for
			   
			   //output.flush();
			   output.write(str);
			   output.write("\n");
		   }
		   
		   // output the idf
		   for(String word: tf_idf.keySet()){ 
			   System.out.println(word + " : " + tf_idf.get(word) );
			   
		   } 
		   
		} catch (Exception e) {
		   e.printStackTrace();
		   
	    }
		
		output.close();
		
	}
	
	// using the TF-IDF approach
	public void processword(String line){
		String[] words = line.split("");
		LinkedHashMap<String, Integer> tf = new LinkedHashMap<String, Integer>(); //store the tf in inserted order
		
		String regex = "[。，,！（）: ; 、 ” “ … ?]";
		String en = "[a-zA-Z]";
		for(int i=0; i<words.length; i++){
		   if(!words[i].isEmpty()){ // remove the 1st one
			
			//strip punctuation
			if (!words[i].matches(".*" + regex + ".*") && (!words[i].matches(".*" + en + ".*"))){
				
			   // remove the english ?
				
			    String word = words[i];
			    // the tf in each line/review
			    if(!tf.containsKey(word)){ // this word isnot in the review
			       tf.put(word, 1);
			    } else{
				   Integer val = tf.get(word) + 1; // get the value
				   tf.put(word, val);
			    }
			    
			    // the idf in the corpus
			    if(!idf.containsKey(word)){
			    	idf.put(word, 1);
			    }else{
			    	Integer idf_val = idf.get(word) + 1;
			    	idf.put(word, idf_val);
			    }
			 
		     }
		   } //if
		   
		} // for
		
		// tf normalization
		LinkedHashMap<String, Double> norm_tf = new LinkedHashMap<String, Double>(); //
		int n = tf.size();
		for(String word: tf.keySet()){ 
			//System.out.println(word + " : " + idf.get(word) );
			//double norm_tf_val = Math.log10(tf.get(word)) + 1 ;
			double norm_tf_val = (double)tf.get(word) / n ;
			norm_tf.put(word, norm_tf_val);
		} 
		
		lines.add(norm_tf);
		
	}
	
	//test
	public static void main(String[] args) throws IOException{
		//System.out.println("Hello, World");
		//boolean status = true; // whether positive or negative
		
		DataProcessing data = new DataProcessing();
		
		String path = "/Users/zhaowenlong/workspace/proj/dev.mycode/java/codingtest/data/";
		// write file
		//if (status){ // load 
		 //   File file = new File(path + "training_exp.dat");
		 //   FileWriter fw = new FileWriter(file.getAbsoluteFile());
		 //   BufferedWriter output = new BufferedWriter(fw);
		
		data.loaddata( path + "_testing.data",
				       path + "testing_exp.dat");
		//} else {
			
		//}
		
		//output.flush();
		//output.close();
		
  }
     
}
