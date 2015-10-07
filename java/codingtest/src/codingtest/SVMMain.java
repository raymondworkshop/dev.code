package codingtest;


////a linear svm library used
//import svm.SVM;  
//import svm.Problem;
//import svm.KernelParams;
//import svm.EvalMeasures;
//import svm.FeatureNode;

import java.util.*;
import java.io.BufferedReader;
import java.io.FileReader;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.BufferedWriter;


/**
 *  Classification, 
 *  
 *  svmlearn (linear svm) lib is used here,
 *  
 *  svmlight / libsvm is better
 *
 */

public class SVMMain {

	/*
	public static void crossvalidation(SVM model){
		int i;
		int total_correct = 0;
		
		double C = 1;
		model.setC(C); //
		
		model.svmTrain(train, kp, 1);
	}*/
	
	/*borrow from svm lib*/
	public static FeatureNode [] parseRow(String [] row) {
		FeatureNode [] example = new FeatureNode[row.length-1];
		int maxindex = 0;
		for (int i=1; i<row.length; i++) {
			String [] iv = row[i].split(":");
			int index = Integer.parseInt(iv[0]);
			if (index <= maxindex) {
				throw new IllegalArgumentException("indices must be in increasing order!");
			}
			maxindex = index;
			double value = Double.parseDouble(iv[1]);
			example[i-1] = new FeatureNode(index, value);
		}
		
		return example;
	}
	/*
	public static void loadproblem(String filename){
		String line;
		ArrayList<FeatureNode []> examples = new ArrayList<FeatureNode []>();
		try {
			BufferedReader in = new BufferedReader(new FileReader(filename));
			for (line = in.readLine(); line != null; line = in.readLine()) {
				String[] elems = line.split(" ");

				examples.add(parseRow(elems));
			}

		} catch (Exception e) {
			 e.printStackTrace();
		}
		
	}*/
	
	public static void main(String[] args) throws IOException{
		SVM s = new SVM();
		
		Problem train = new Problem();
		Problem test = new Problem();
		
		// load data -- imbalanced dataset ----
		String path = "/Users/zhaowenlong/workspace/proj/dev.mycode/java/codingtest/data/";
		
		//train.loadBinaryProblem(path + "train");
		//test.loadBinaryProblem("test");
		train.loadBinaryProblem(path + "training_file.dat");
		test.loadBinaryProblem(path + "test_file.dat");

		
		System.out.println("Training...");
		// parameter searching -  grid - cross_validation 
		// here we use linear svm - just for the regularisation parameter C
		//
		
		// train a  model
		KernelParams kp = new KernelParams(); //linear

		// for the parameter searching, the regularisation parameter C
		
		double acu = 0.8; // default accuracy
		double C = 1; // default value
		double c_begin = 0.01;
		int c_end = 3;
		double c_step = 0.5;
		for(double i = 0.1;  i <= c_end; i+=c_step){
			double c_test = i + c_begin + (double)c_step;
		    s.setC(c_test); //
		    
		    s.svmTrain(train, kp, 1); //SMO_platt is used here
//			s.svmTrain(train);
		    
		    //crossvalidation(s);
		
           System.out.println("Testing...");
		   int [] pred = s.svmTest(test);
		   /*
		   for (int j=0; j<pred.length; j++)
			   System.out.println(pred[j]);
			   */
		
		   EvalMeasures e = new EvalMeasures(test, pred, 2);
		   System.out.println("Accuracy=" + e.Accuracy());
		
		   if(e.Accuracy() > acu){
			   acu = e.Accuracy();
			   
			   C = c_test;
		   }
		}
		
		// predict the test data
		SVM s1 = new SVM();
		s1.setC(C);
		s1.svmTrain(train, kp, 1);
		
		Problem predict = new Problem();
		predict.loadproblem(path + "/testing_exp.dat"); //each line is a review

		System.out.println("Predicting...");
		int [] pred_ = s1.svmTest(predict);
		
		
		// write the result -- a I/O function is better
		String line;
		String re =  "/Users/zhaowenlong/workspace/proj/dev.mycode/java/codingtest/result/";
	    File pos_file = new File(re + "result-positive.data");
	    FileWriter pos_fw = new FileWriter(pos_file.getAbsoluteFile());
	    BufferedWriter pos_output = new BufferedWriter(pos_fw);
	    
	    File neg_file = new File(re + "result-negative.data");
	    FileWriter neg_fw = new FileWriter(neg_file.getAbsoluteFile());
	    BufferedWriter neg_output = new BufferedWriter(neg_fw);
		
	    System.out.println("Writing the files ...");
	    BufferedReader in = new BufferedReader(new FileReader(path + "testing.data"));
	    
	    int j = 0; // line
	    for (line = in.readLine(); line != null; line = in.readLine()) {
			  // System.out.println(line);
			   
				if(pred_[j] < 0){ // -1
					neg_output.write(line + "\n");
					
				} else if (pred_[j] > 0){ // 1
					pos_output.write(line + "\n");
					
				}
				
				j++; // next line
		}
		
	    //
	    in.close();
	    neg_output.close();
	    pos_output.close();
		
		System.out.println("Done.");
	}

}
