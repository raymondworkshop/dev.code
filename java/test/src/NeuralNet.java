package test;

import java.io.*;

public class NeuralNet {
 
	  // instance
	  private  int num_neur_input;
	  private  int hidden_layer;
	  private  int num_neur;
	  private  int num_neur_output;
	  private  String function;
	  private double[][] matrices;
	  private double[] vector;
	  
	  //constructor
	  public NeuralNet(int num_neur_input,int hidden_layer, int num_neur, int num_neur_output) { 
		  
		  this.num_neur_input = num_neur_input;
		  this.hidden_layer = hidden_layer;
		  this.num_neur = num_neur;
		  this.num_neur_output = num_neur_output;
		  
	  }
		 
	
	  // function
	  public static void train(String input, String output, int layer, int input_neurons, int hidden_neurons, int output_neurons, int cate_num, float rate){
	      
	  }
	  
	  //test
	  public static void test(String input, String output){
		  
	  }
	  
	  //save
	  public static void save(String input){
		  
	  }
	  
	  //load
	  public static void load(String input){
		  
	  }
	  
	  
	 
	   //test
		public static void main(String[] args) throws IOException{
			
		}

}
