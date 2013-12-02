//InterfacesImpl.java
//java class can implement mul inheritance.
public class InterfacesImpl implements InterfaceA, InterfaceB, InterfaceC {
    //@Override
    public void printIt(){
        System.out.println("the implementation of concrete class");
    }

    public static void main(String[] args){
        InterfaceA objA = new InterfacesImpl();
        InterfaceB objB = new InterfacesImpl();
        InterfaceC objC = new InterfacesImpl();

        //go to the same concrete implementation
        objA.printIt();
        objB.printIt();
        objC.printIt();
    }
        
}

