//Daughter.java
// Anonymous inner class
public class Daughter extends Mother implements FatherIF {
    @Override
    public int getStrong(){
        //create an object of an anonymous class that's inherited from Father
        return new Father(){ //Insert a class definition
            @Override
            public int getStrong(){
                return super.getStrong() - 2;
            }
        }.getStrong(); //
    }

    public int getKind(){
        return super.getKind() + 1;  //kinder than mother
    }

    public static void main(String[] args){
        Daughter daughter = new Daughter();

        System.out.println(Integer.toString(daughter.getStrong()));  //6
        System.out.println(Integer.toString(daughter.getKind()));  //9
    }
    
        
}

