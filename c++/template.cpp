//template.cpp: template review

#include <iostream>
using namespace std;

template <typename T>
T Bigger(const T &v1, const T &v2)
{
    return v1>v2 ? v1 : v2;
}

template <typename T>
T AbsVal(T val)
{
    return val>0 ? val : -val;
    
}
//declare a template
template <typename T, typename U> int compare(const T&, const U&);


int main()
{
    //1. syntax
    //T is int; compiler instantiates int compare(const int&, const int&)
    cout << Bigger(1,0) <<endl;
    // T is string
    string s1 ="h1";
    string s2 = "world";
    cout << Bigger(s1, s2) <<endl;

    //2.
    double dval = 0.88;
    float fval = -12.3;
    cout << AbsVal(-3)<<endl;
    cout<<AbsVal(dval)<<endl;
    cout<<AbsVal(fval)<<endl;
    
    //3. class template
    //template <class T> class Queue{};
        
    return 0;
    
}

