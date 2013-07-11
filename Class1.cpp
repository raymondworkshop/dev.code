// code about copy-control idea
#include <vector>
#include <iostream>
using namespace std;

class Exam
{
public:
    //default constructor
    Exam(){ cout << "Exam()" <<endl;}
    // copy constructor
    Exam(const Exam &){cout<< "Exam(const Exam&)" <<endl;}

    // assignment operator
    Exam &operator = (const Exam &)
    {
        cout<<"Operator" <<endl;
        return *this;
        
    }

    //destructor
    ~Exam()
    {
        cout<< "~Exam()" <<endl;
        
    }
    
};

void func1(Exam obj){} //

void func2(Exam &obj){}

Exam func3()
{
    Exam obj; //call default constructor to construct local Exam obj
    return obj; // call copy constructor to construct the copy of Exam obj
    
} // call destructor

int main()
{
    // call default constructor
    Exam eobj;
    
    // call copy constructor
    // then a copy from eobj to Exam obj, pass by value,
    // then destructor Exam obj
    func1(eobj);
    
    // since a reference, needn't call copy constructor to pass 
    func2(eobj);
    
    cout<<"func3"<<endl;
    //func3: call default constructor to construct local Exam obj,
    //       call copy constructor to construct the copy of Exam obj
    //       call deconstructor to free local Exam obj
    //here:  call assignment operator
    //       after assigning, call deconstructor to free the copy of Exam obj
    eobj = func3();
    
    cout<<"pointer function"<<endl;
    // call default constructor to construct Exam dynamicall    
    Exam *p = new Exam;
    
    //call default constructor to construct a temp Exam object
    //call copy constructor three times
    //copy the temp Exam object to vector container
    //call destructor to free temp Exam object
    vector<Exam> evec(3);

    //call destructor to free Exam object dynamically
    delete p;
    
    // call destructor to free evec(3 times) and eobj
    return 0;
    
}





    
