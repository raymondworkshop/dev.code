//Managing pointer members
#include <iostream>
using namespace std;

class Ptr
{
private:
    int *ptr;
    int val;
public:
    Ptr(int *p, int i): ptr(p), val(i) {}

    //const members, the functions only read the data member (like ptr, val) and can't change them
    // also, const function can't call no-const function
    int *Getptr() const { cout<<ptr<<endl;}
    int Getint() const { cout<<val<<endl;}

    //non cosnt members to change the indicated data member
    void Setptr(int *p) { ptr = p;}
    void Setint(int i) {val = i;}

    // return or change the value pointed to, so ok for const objects
    int GetptrVal() const { cout<<*ptr<<endl;}
    void SetptrVal(int val) const { *ptr = val ;} // the function doesn't change the pointer not the value the pointer points to

};

// the class is private, we don't hope the user to use UsePtr,
//Also, Ptr's function member can visit UsePtr
class UsePtr
{
private:
    int *ip;
    int use;
    
    UsePtr(int *p): ip(p), use(1){}
    ~UsePtr() {delete ip;}
friend class Ptr;
    
};
    

int main()
{
    int obj = 0;
    Ptr ptr1(&obj, 42);
    // there is no copy constructor, so
    Ptr ptr2(ptr1); // now ptr in ptr1 and ptr2 point to the  obj
    ptr1.Getptr(); // the same value
    ptr2.Getptr(); // the same value
    
    ptr2.GetptrVal(); // 0
    //----
    // int is independent in the two object
    ptr1.Setint(1); // change val only in ptr1
    ptr2.Getint(); // 42
    ptr1.Getint(); //1
        
    //Problem1: ptr1 and ptr2 in different object point to the same obj, so each can change the shared value
    ptr1.SetptrVal(42);
    ptr2.GetptrVal(); //42
    
    //Problem2: Dangling pointers
    int *ip = new int(42);
    Ptr ptr(ip,10); // now ptr points to same object as ip does
    delete ip; // ojbect pointed to by ip is freed
    //ptr.SetptrVal(0); // disaster: the object to which has Ptr points was freed

    //so, we need to define smart pointer classes to solve the above problems
    //defining smart pointers use a use count, which associates a counter with the object to which the class points
    // The use count keeps track of how many objects of the class share the same pointer,
    //when the use count goes to zero, then the object is deleted (p573 in c++ primer)
    // we define a count class UsePtr
    //TODO
    
    
    
}


    

