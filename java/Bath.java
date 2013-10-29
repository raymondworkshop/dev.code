//Bath.java: muyun
//constructor initialization wiht composition

class Soap
{
    private String s;

    //1) in the constructor
    Soap()
    {
        System.out.println("Soap()");
        s = "Soap Constructed";
    }

    public String toString()
    {
        return s;
    }
    
}

public class Bath
{
    //2)initializing at point of definition, which means that they'll always be initialized before the constructor is called
    private String s1="Happy", s2="Happy2", s3, s4;

    private Soap castille;
    private int i;
    private float toy;

    public Bath()
    {
        System.out.println("Bath()");
        s3 = "Joy";
        toy = 3.14f;
        castille = new Soap();
    }

    //3) instance initialization;
    //the java compiler copies the code of instance initializer block in every constructor;
    //Instance initializer block is used to initialize the instance data member;
    //it run each time when object of the class is created
    {System.out.println("instance initializer block invoked");}

    public String toString()
    {
        if(s4 == null) //delayed initialization
            s4 = "Joy";
        
        return "s1 = " + s1 + "\n" +
               "s2 = " + s2 + "\n" +
               "s3 = " + s3 + "\n" +
               "s4 = " + s4 + "\n" +
               "castille = " + castille;
    }

    public static void main(String[] args)
    {
        Bath b = new Bath();
        System.out.println(b);
    }
        
}

/*
instance initializer block invoked
Bath()
Soap()
s1 = Happy
s2 = Happy2
s3 = Joy
s4 = Joy
castille = Soap Constructed
*/
