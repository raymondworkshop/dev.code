package exercise;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Stack;

public class Str {
	public static String Join(String[] words){
		//String word = "";
		StringBuffer word = new StringBuffer();
		for(String w : words){
			//word = word + w;
			word.append(w);
		}
		
		return  word.toString();
	}
	
	// ArrayList - dynamically resizing array - O(1)
	public static ArrayList<String> Merge(String[] words1, String[] words2){
		ArrayList<String> sentence = new ArrayList<String>();
		
		for(String w : words1)
			sentence.add(w);
		
		for(String w : words2)
			sentence.add(w);
		
		return sentence;
	}
	
	//hash tables
	public static HashMap<Integer, String> buildmap(String[] words){
		HashMap<Integer, String> map = new HashMap<Integer, String>();
		for(String w : words){
			int i = 1;
			map.put(i++, w);
		}
		
		return map;
	}
	
	
	// compress - 
	public static String Compress(String str){
		//char[] s = str.toCharArray();
		String mystr = "";
		
		char last = str.charAt(0);
        int count = 1;
        for(int i = 1 ; i<str.length(); i++){
        	if(last == str.charAt(i)){
        		count++;
        	} else {
        		mystr += last + "" + count;
        		
        		last = str.charAt(i);
        		count = 1;
        	}
        }
        
        return mystr + last + count;
	}
	
	// reverse words in a string in-place
	public static String ReverseWords(String str){
		if(str == null || str.length() == 0)
			return "";
		
		String[] arr = str.split(" ");
		StringBuilder sb = new StringBuilder();
		for(int i = arr.length -1 ; i >=0; --i){
			if(!arr[i].equals("")){
				sb.append(arr[i] + " ");
			}
		}
		return sb.toString();
	}
	
	// test
	public static void main(String args[]){
		String[] words =  {
				"ice", "cream","who","am"
		};
		
		String word = Join(words);
		System.out.println(word);
		
		String[] words1 = {"hello", "world", "!"};
		String[] words2 = {"I", "am", "coming"};
		
		String str = Merge(words1, words2).toString();
		System.out.println(str);
		
		System.out.println(Compress("aabcccccaaa"));
		
		String s = "the sky is blue";
		System.out.println(ReverseWords(s));
	}

}
