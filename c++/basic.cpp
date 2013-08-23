// c++ basic training
#include <iostream>
//#include <string>
using namespace std;

int main()
{
    //1. const qualifier
    //    1) can't change the value
    //    we must initialize it when the object is defined
    const int bufSize = 512;
    cout<<bufSize<<endl;
    
    //bufSize = 0; // error
    //    2) const object is local to a file by default
    //       so add the key extern
    //extern const int X = 512;

    //2. A reference is an alias
    //   A reference must be initialized using an object of the same type
    int ival = 1024;
    int &refVal = ival;
    //int&refVal3 = 10; // error
    cout << refVal<<endl;

    //3. typedef define a synonym for a type
    typedef double wages;
    wages hour = 3.10;
    cout <<hour<<endl;

    //4. enum not only define but also group sets of integral constants
    enum open_modes {input =0, output,append};
    cout << output<<endl;

      return 0;
}

