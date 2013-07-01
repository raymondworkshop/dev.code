// Reference is like an alias to some variable
// A reference (&) is like a constant pointer that is auto dereferenced
//
// Any reference must be tied to someone else's piece of storage, when you
// access a reference, you're accessing that storage
#include <iostream>
using namespace std;

int* f(int* x)
{
    (*x)++;
    return x;    
}

int& g(int& x)
{
    x++;
    return x;
    
}

void PointerSwap(int* p1, int* p2)
{
    int temp;
    temp = *p1;
    *p1 = *p2;
    *p2 = temp;
    
}

void ReferenceSwap(int& a, int &b)
{
    int temp;
    temp =a;
    a=b;
    b=temp;
    
}


int main()
{
    int a = 0;
    cout<<*f(&a)<<endl;
    cout<<g(a)<<endl; // clean but hidden

    // swap
    int i = 3, j = 5;
    PointerSwap(&i, &j); // pointer p1->3, p2->5
    cout<<i<<" "<<j<<endl;

    ReferenceSwap(i,j); // i is alias of a, and j is alias of b
    cout<<i<<" "<<j<<endl;
    
}



