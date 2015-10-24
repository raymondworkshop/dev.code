package exercise;
/*
 * TODO:
*/

public class ctest{
	public static void convert(String s){
		for(int i=s.length() -1; i>=0; i--){
			System.out.print(s.charAt(i));
		}
		System.out.println();
	}
	
	//test
	public static void main(String[] args){
		String str = "this is a computer";
		ctest.convert(str);
	} 
}