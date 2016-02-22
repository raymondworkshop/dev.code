package basic;
/*Prove that class loading takes place only once. Prove that loading may be caused
* by either the creation of the first instance of the that class of by access of a 
* static member. */

class A {
	static int j = printInit("A.j initialized");
	static int printInit(String s) {
		System.out.println(s);
		return 1;
	}
	A() { System.out.println("A() constructor"); }	
} 

class B extends A {
	static int k = printInit("B.k initialized");
	B() { System.out.println("B() constructor"); }	
}
	
class C {
	static int n = printInitC("C.n initialized");
	static A a = new A();	
	C() { System.out.println("C() constructor"); }
	static int printInitC(String s) {
		System.out.println(s);
		return 1;
	}
}

class D {
	D() { System.out.println("D() constructor"); }
}

public class LoadClass extends B {
	static int i = printInit("LoadClass.i initialized");
	LoadClass() { System.out.println("LoadClass() constructor"); }
	public static void main(String[] args) {
		// accessing static main causes loading (and initialization)
		// of A, B, & LoadClass
		System.out.println("hi");
		// call constructors from loaded classes:
		LoadClass lc = new LoadClass();
		// call to static field loads & initializes C:
		System.out.println(C.a);
		// call to constructor loads D:
		D d = new D();
	}
}

/*
wenlongzhao@Stars-MacBook-Pro:java$ java LoadClass
A.j initialized
B.k initialized
LoadClass.i initialized
hi
A() constructor
B() constructor
LoadClass() constructor
C.n initialized
A() constructor
A@70a0afab
D() constructor
*/
