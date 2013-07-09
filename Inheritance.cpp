//Inherience.cpp
//
#include <iostream>
using namespace std;

class Base
{
private: int b_number;
public:
    Base() {}
    Base(int i):b_number(i) {}
    int GetNumber() 
    {
        return b_number;
    }

    void print()
    {
        cout<<"this is a" <<endl;
        cout<< b_number <<endl;
        
    }
};

class Derived: public Base
{
 private: int d_number;
 public:
    // constructor initializer list
    // When an object is created, the compiler guarantees that constructors for all its subobjects
    // are called. But if you want to change a default argument in a constructor, the new class constructor
    // doesn't have permission to access the private data elements fo the subobject, so it can't initialize
    // them directly
    Derived(int i,int j):Base(i),  d_number(j) {}
    void print()
    {
        cout<<GetNumber()<< ",";
        cout<<d_number<<endl;
        
    }
    
};

int main()
{
    cout<<"The basic inheritance knowledge:"<<endl;
    Base a(3);
    //cout<< "a is";
    a.print();
    
    Derived b(2,5);
    b.print();

    b.Base::print(); // print in Base
    cout<<"--------------"<<endl;
    
    return 0;
    
}


    
