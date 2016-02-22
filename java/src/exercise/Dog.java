package exercise;

// Is-A relationship

//Mul Inheritance
interface Animal{
	public void bark();
	public void sleep();
}

//a class can implement one or more interfaces
class Mammal implements Animal{
	public void bark(){
		System.out.println("Mammal brak");
	}
	
	public void sleep(){
		System.out.println("Mammal sleep");
	}
}

public class Dog extends Mammal{
	// constructor
	public Dog(){
	}
	// the object's state is stored in fields
	String breed;
	int age;
	String color;
	
	// behavior is via methods
	//void bark(){
	//}
	
	//void sleep(){
	//}

	public static void main(String args[]){
		Mammal m = new Mammal();
		Dog d = new Dog();
		
		System.out.println(m instanceof Animal);
		System.out.println(d instanceof Mammal);
		System.out.println(d instanceof Animal);
	}
}