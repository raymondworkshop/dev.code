//Sequence2.java
// Chapter Innerclasses, Exercise 2
// a class that holds a String, and has a toString() method that displays this String,
package innerclasses;

class Word {
    private String word;
    public Word(String s){
        word = s;
    }
    public String toString(){
        return word;
    }
}

//Iterator design pattern
interface Selector {
    boolean end(); //at the end
    Object current();  // access the current Object
    void next(); // move to next Object
}

public class Sequence2 {
    private Object[] items;
    private int next = 0;
    public Sequence2(int size){
        items = new Object[size];
    }

    public void add(Object x){
        if(next < items.length)
            items[next++] = x;
    }

    //SequenceSelector is a private class that provides Selector functionality
    private class SequenceSelector implements Selector {
        private int i = 0;
        //the inner class can access methods and fields from the enclosing object that made it
        //like itmes here
        public boolean end() { return i == items.length; }
        public Object current() { return items[i]; }
        
        public void next(){
            if(i < items.length)
                i++;
        }
                
    }

    public Selector selector(){
        return new SequenceSelector();
    }

    public static void main(String[] args){
        Sequence2 sequence = new Sequence2(10);
        for(int i = 0; i<10; i++)
            sequence.add(new Word(Integer.toString(i)));

        Selector selector = sequence.selector();  //?
        while(!selector.end()){
            System.out.print(selector.current() + " ");
            selector.next();
        }
        System.out.println();
        
    }
}

