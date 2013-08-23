//Explict tells the compiler that it isnot allowed to make one implicit conversion
// to resolve the parameters to a function

// Sometimes, this will cause issues and the cost is the hidden constructor call
#include <iostream>
using namespace std;

class Foo
{
private:
    int f;
public:
    //Foo (int foo): f(foo) {}
    explicit Foo (int foo): f(foo) {}

    int GetFoo () { cout<< f <<endl;}
};

void DoBar (Foo foo)
{
    int i = foo.GetFoo ();
    
}

int main()
{
    //DoBar (42); // Here the parameter isnot a Foo object but an int
                // But, the constructor for Foo that takes an int so
                // the constructor can be used to convert
    DoBar(Foo (42));
    
}

    
