//
#include <iostream>
using namespace std;

int main()
{
    int a =0;
    //pointer to const
    const int* u = &a; // u is a pointer,pointing to a const int 
    int const* v;

    //const pointer
    int d = 1;
    int* const w = &d; // w is a const pointer, pointing to int

    //const int* const x = &d;

    cout<< *w <<endl;

    *w = 2;
    cout<< *w <<endl;

    // *u = 3;
    cout<< *u <<endl;
    
}



    
