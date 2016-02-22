package exercise;

// Polymorphism -
//when a parent class reference is used to refer to a child class object
//

//reference variable

class Employee{
	private String name;
	private String addr;
	private int number;
	
	public Employee(String name, String addr, int number){
		this.name = name;
		this.addr = addr;
		this.number = number;
	}
	
	public void CheckMail(){
		System.out.println("Mailing a check to " + this.name + " " + this.addr);
	}
	
	public String GetName(){
		return name;
	}
}

public class Salary extends Employee {
    private double salary;
    
    public Salary(String name, String addr, int number, double salary){
    	super(name, addr, number);
    	this.salary = salary;
    }
    
    public void CheckMail(){
    	System.out.println("Mailing a check to " + GetName() + " with salary " + salary );
    }
    
    public static void main(String args[]){
    	// Salary reference
    	Salary s = new Salary("Mohd", "Ambehta", 3, 3600.00);
    	// employee reference
    	
    	Employee e = new Salary("John", "Boston", 2, 2400.00); //
    	
    	s.CheckMail();
    	
    	//compiler uses CheckMail() in Employee class
    	// at run time, the JVM invokes CheckMail() in Salary clsss
    	e.CheckMail(); // overridden 
    }
}
