//Son.java
package interfaces.multipleInheritance;

//son class inherits Mother and Father, using inner class
//
public class Son extends Father implements MotherIF {
    //class myMother inherits Mother class;
    //inner class can inherit a mother class which is independent with Father to guarantee the independence
    private class myMother extends Mother {
        public int getKind(){
            return super.getKind() - 1; //less kind than mother
        }
    }
    
    @Override
    public int getKind(){
        return new myMother().getKind();
    }

    @Override
    public int getStrong(){
        return super.getStrong() + 1; //stronger than father
    }

    public static void main(String[] args){
        Son son = new Son();

        System.out.println(Integer.toString(son.getKind()) );  //7
        System.out.println(Integer.toString((son.getStrong())) );  //9
        
    }
            
}

