//array and pointer
#include <iostream>
#include <string>
#include <vector>
using namespace std;

int main()
{
    //1. array initialize
    const unsigned size =3;
    int array[size] ={0,1,2};
    //diff from vector, array can't add new elements any more after the definition
    //now we often replace array with vector and iterator

    //2. pointer
    //diff from iterator, which is only used in the vector
    //pointer keeps the address of another object

    // don't use the unitialized pointer
    vector<int> *pvec = 0; // pvec points to a vector<int>

    string s1("some value");
    string *sp1 = &s1;
    cout<< *sp1<<endl; // dereference, * can get the object the point points to
    
    string s2("another");
    string *sp2 = &s2;
    cout<< *sp2 <<endl;
    
    *sp1 = "a new value"; //assign s1 through sp1, s1 now is "a new value"
    cout<< s1<<endl;  // "a new value"

    sp1= sp2; //assign to sp1, now sp1 points to s2
    cout<<*sp1<<endl; // "another"

    //3. difference pointer from reference
    // 1) a reference must point to the same object and must be initialize
    // 2) changing reference changes his object's value, not points to another value
    int ival = 1023, ival2 = 2048;
    int *pi = &ival, *pi2 = &ival2;
    pi = pi2; // now pi points to ival2
    cout<< ival<<endl; // 2048
    // while
    int &ri = ival, &ri2 = ival2;
    ri = ri2; // now ival = ival2
    cout << ival<<endl; // 2048
    
    //pointer meets const
    //4. a pointer points to const object
    // C++ require this pointer must keep const characher
    // the definition is const double *cptr,
    const double piii = 3.14;
    //cptr is a pointer to const
    //we can't change pi through cptr
    const double *cptr = &piii; 
    //double *ptr = &pi; // error, ptr is a plain pointer
    // pointers to const occur most often as formal parameters of functions;
    // Defining a parameter as a pointer to const, guaranteeing that
    // the actual object being passed into the function will not be modified through that parameter

    //5. const pointer
    // the pointer itself can't be changed
    // which means that the object it points to can be changed
    // because the object the pointer point to depends on the object's type
    int errNumb = 0;
    int *const curErr = &errNumb; // curErr is const pointer which point to int object
    
    // const pointer points to const object
    const double pii = 3.14;
    const double *const p =&pii;
    
    //dynamic array
    int *pia = new int[10]; // allocate an array of 10 int element and return a pointer pointing to 1st element
    int *q;
    int i=0;
    for(q=pia; q != pia + 10; ++q)
        *q = ++i;

    delete [] pia;
    *pia = 0;
                
    return 0;
}

