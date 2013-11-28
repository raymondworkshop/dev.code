//Ex19.java
//nested class;
//a class containing an inner class that itself contains an inner class
//reference to the exercise19 in "Thinking in java"
//
public class Ex19 {
    Ex19() {
        System.out.println("Ex19()");
    }

    private class Ex19Inner {
        Ex19Inner(){
            System.out.println("Ex19Inner()");
        }

        // a class containing an inner class that itself contains an inner class
        private class Ex19InnerInner { 
            Ex19InnerInner(){
                System.out.println("Ex19InnerInner()");
            }
        }
    }

    private static class Ex19Nested {
        Ex19Nested() {
            System.out.println("Ex19Nested()");
        }
        //1. make the inner class static:
        //needn't a connection between the inner-class object and the outerclass object
        private static class Ex19NestedNested {
            Ex19NestedNested(){
                System.out.println("Ex19NestedNested()");
            }
            
        }
    }

    public static void main(String[] args){
        Ex19Nested en = new Ex19Nested();
        Ex19Nested.Ex19NestedNested enn = new Ex19Nested.Ex19NestedNested();

        Ex19 e19 = new Ex19();
        Ex19.Ex19Inner ei = e19.new Ex19Inner();  //create inner class object
        Ex19.Ex19Inner.Ex19InnerInner eii = ei.new Ex19InnerInner();
    }
        
}

/* compiler produces:
* Ex19$Ex19Inner$Ex19InnerInner.class
* Ex19$Ex19Inner.class
* Ex19$Ex19Nested$Ex19NestedNested.class
* Ex19$Ex19Nested.class
* Ex19.class
*/

