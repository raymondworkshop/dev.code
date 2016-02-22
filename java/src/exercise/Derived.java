package exercise;
//

class Base {
	private final int  a = 5;
	
	public int getAge(){
		return a;
	}
	
	public void f(){
		System.out.println("Base");
	}
	
	//static - needn't have an instance
	public static void f1(){
		System.out.println("Base");
	}
	
	//overload
	public void f(String a){
		System.out.println("Base " + a);
	}
}

public class Derived extends Base {
	private final int a = 7;
	
	// polyu and overriding are applicable only to non-static mthods
	@Override
	public void f(){
		System.out.println("DerivedOne");
	}
	
	//
	public static void f1(){
		System.out.println("DerivedOne");
	}

	//test
	public static void main(String[] args){
		Base b = new Base();
		b.f();
		//b.f1();
		//override
		b = new Derived();
		b.f();
		//b.f1();
	}
}
