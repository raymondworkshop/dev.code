package test;

/*
 * the alg:
 *   38798 56637 /Users/zhaowenlong/workspace/proj/dev.mycode/java/test/bin/result.txt
 *   
 * the output:
 *   100101111000111*
100101111001****
10010111101*****
1001011111******
10011***********
101*************
110111010011110*
11011101001110**
1101110100110***
110111010010****
11011101000*****
11011100********
110110**********
11010***********
1100************
 in the defined file
 * 
 * */

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.BufferedWriter;
//import java.io.IOException;

public class Convert {
	
	private Convert() { }
	
	public static void transfer(int a, int b, String path) throws IOException{
		//by default a < b
		
		File file = new File(path);
		//FileWriter fw = new FileWriter(file);
		//BufferedWriter output = new BufferedWriter(fw);
		
		FileWriter fw = new FileWriter(file.getAbsoluteFile());
		BufferedWriter output = new BufferedWriter(fw);
		
		//String bin_a = toBase(a);
		//String bin_b = toBase(b);
		
		//char[] bin_a = toBase(a).toCharArray();
		//char[] bin_b = toBase(b).toCharArray();
		
		int x = 0;
		String str =""; // the output
		
		int a_tmp = a;  // backup a
		while(a_tmp < b){
		   //how many continuous '0' at the end of 'a'
		   int cnt_tmp = checkzeros(a_tmp);
		   if (cnt_tmp == 0){
			   
			   //put it in the set
			  str = stroutput(a_tmp, cnt_tmp);
			   try {
				   output.write(str);
				   output.write("\n");
				System.out.println(str);
				
			   } catch (IOException e) {
				   
			   }
			   
			   a_tmp = a_tmp + 1;
			   
		   } else{ // if there is
		      
			  // change to , like 10000-> 11111
		      //x =  a_tmp + 2^(cnt_tmp)-1;
		      x = a_tmp + (int)Math.pow(2, cnt_tmp) - 1;
		   
		      if(x <= b){
			     //output it in the set
		    	  str = stroutput(a_tmp, cnt_tmp);
				   try {
					   output.write(str);
					   output.write("\n");
						System.out.println(str);
						
					   } catch (IOException e) {
						   
						   
					   }
			     
				   //
			       //tmp = x + 1;
			  }
		      
		      a_tmp = x + 1;
		      
		   }  //else
		} //while   
		   
		// if x > b
		int b_tmp = b;
		while(a < b_tmp){ // x > b
			     //b = b - 1;
			     int cnt_b = checkones(b_tmp);
			     if (cnt_b == 0){ // '0'
			    	 //put this in the set
			    	  str = stroutput(b_tmp, cnt_b);
					   try {
						   output.write(str);
						   output.write("\n");
						   
						   System.out.println(str);
						   
						   } catch (IOException e) {

						   }
					   
					   b_tmp = b_tmp - 1;
			    	 
			     } else { // if there is '1'
			    	 //int y = b_tmp - (2^(cnt_b) - 1);
			    	 int y = b_tmp - ((int)Math.pow(2, cnt_b) - 1);
			    	 
			    	 if ( y >= a) {
			    		 // put this in the set
			    		 str = stroutput(b_tmp, cnt_b);
						 
			    		 try {
			    			 output.write(str);
			    			 output.write("\n");
			    			 System.out.println(str);  
							   } catch (IOException e) {

							   }
			    		 
			    		 //
			    		  //b = y - 1;
			    	 }
			    	 
			    	 b_tmp = y -1;
			    	 
			    	 /*
			    	 if ( a >= y){
			    		 break;
			    	 }*/
			     }
			        
			 }
		
		//close
		//output.flush();
		output.close();
		   
	}
	
	public static String stroutput(int n, int cnt){
		String bin = "";
		/*
		int tmp = n/2 + 1;
      
		for(int i = 0; i < tmp; i++){
			try{
				bin += "" + n % 2;
				
				n /= 2;
				
			} catch(Exception e){
				
			}
		}
		*/
		
		int tmp = n / (int)Math.pow(2, cnt);
		
		// the binary representation of tmp
		String str = Integer.toBinaryString(tmp);
		
		/*
		// revert
		String str= "";
		for(int i = bin.length() -1; i>=cnt; i--){
			str += bin.charAt(i);	
		}
		*/
		//String str = "";
		for(int c = 0; c < cnt; c++){
			str += '*';
		}
		
		//str = binary + str;
		
		return str;
	}
	
	// how many '0' in the last bits
	public static int checkzeros(int n){
		//StringBuilder binary = new StringBuilder();
		int cnt = 0; // count the last cnt '0'
		int b;
		
		int tmp = n/2 + 1;
      
		for(int i = 0; i < tmp; i++){
			try{
				//bin += "" + n % 2;
				b = n % 2;
				if(b == 0){
					n /=2;
					
					cnt += 1; // one more '0'
					
				} else { // b == 1
					break;
				}
				
			} catch(Exception e){
				
			}
		}
		
		return cnt;
		
	}
	
	// how many ones in the 
	public static int checkones(int n){
		//StringBuilder binary = new StringBuilder();
		int cnt = 0; // count the last cnt '0'
		int b;
		
		int tmp = n/2 + 1;
      
		for(int i = 0; i < tmp; i++){
			try{
				//bin += "" + n % 2;
				b = n % 2;
				if(b == 1){
					n /=2;
					
					cnt += 1; // one more '0'
					
				} else {
					break;
				}
				
			} catch(Exception e){
				
			}
		}
		
		return cnt;
		
	}
	
	//
	public static String tobase(int n){
		//StringBuilder binary = new StringBuilder();
		String bin = "";
		int tmp = n/2 + 1;
      
		for(int i = 0; i < tmp; i++){
			try{
				bin += "" + n % 2;
				
				n /= 2;
				
			} catch(Exception e){
				
			}
		}
		
		// revert
		String binary= "";
		for(int i = bin.length() -1; i>=0; i--){
			binary += bin.charAt(i);
			
		}
		
		return binary;
		
	}
	
	
	//test
	public static void main(String[] args) throws IOException{
		
		int a = Integer.parseInt(args[0]);
		int b = Integer.parseInt(args[1]);
		String path = args[2];
		
		/*
		File file = new File(path);
		//check if the file exists?
		if(!file.exists()){
			try {
				file.createNewFile();
			} catch (IOException e) {
			
			}
		}*/
		
		// assume a < b
		if(a > b){
			int tmp = a;
			a = b;
			b = tmp;
		}
		
		//
        Convert.transfer(a, b, path);
		
        //
		System.out.println("Done");
	}

}
