//FilterAdapter.java
//Interface:
//  2.in the situation of not being able to modify the classes that you want to use.
//    we can use the Adapter design pattern.
//In Adapter, we write code to take the interface that we have and produce the interface that we need
//
package interfaces;

import interfaces.filters.*;

// we find rather than created the library filters, if we want to use the lib filters, we can use it in this way.
// we write code to take the interface filters and produce the interface Processor.
// in this way, decoupling interface from implementation allows an interface to be applied to multiple different implementations,
// and thus our code is more reusable.
class FilterAdapter implements Processor {
    Filter filter;
    //the FilterAdapter constructor takes the interface that we have - Filter
    // 
    public FilterAdapter(Filter filter) {
        this.filter = filter;
    }
    
    // produces an object that has the Processor interface that we need
    public String name(){
        return filter.name();
    }
    
    public Waveform process(Object input){
        return filter.process((Waveform) input);
    }
    
}

public class FilterProcessor {
    public static void main(String[] args){
        Waveform w = new Waveform();
        
        Apply1.process(new FilterAdapter(new LowPass(1.0)), w);
        Apply1.process(new FilterAdapter(new HighPass(2.0)), w);
        Apply1.process(new FilterAdapter(new BandPass(3.0, 4.0)), w);
    }
    
}


