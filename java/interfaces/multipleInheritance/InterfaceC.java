//SonC.java
//another way is through interface extends
//This is perfectly fine because the interfaces are only declaring the methods
//and the actual implementation will be done by concrete classes implementing the interfaces,
//so there is no possibility of any kind of ambiguity in multiple inheritance in iherface.
//
interface SonIF extends MotherIF, FatherIF {
    public int getKind();
    public int getStrong();
}

public class SonImpl implements SonIF, MotherIF, FatherIF {
    //
}


