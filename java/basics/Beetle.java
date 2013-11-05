//Beetle.java: wenlong
//description: look at the whole initialization process, including inheritance in java
//
//reference: <<Thinking in java>>
//----------------------------

class Insect
{
    private int i = 9;
    protected int j;

    Insect()
    {
        System.out.println("i = " + i +  ", j = " + j);
        j = 39;
                
    }

    private static int x1 = printInit("Static Insect.x1 initialized");
    static int printInit(String s)
    {
        System.out.println(s);
        return 47;
                
    }
    
}

public class Beetle extends Insect
{
    private int k = printInit("Beetle.k initialized");
    public Beetle()
    {
        System.out.println("k = " + k);
        System.out.println("j = " + j);
    }

    private static int x2 = printInit("Static Beetle.x2 initialized");
    
    public static void main(String[] args)
    {
        System.out.println("Beetle constructor");
        Beetle b = new Beetle();
        
    }
    
}


