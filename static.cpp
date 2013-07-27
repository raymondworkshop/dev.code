// static function in c++
// and the use of cin to get input
#include <iostream>
using namespace std;

void fun()
{
    static int i = 0; // static means that variable i keep invariable, only init on the first call
    cout<<"i=" << ++i<<endl;  // i=1, i=2,i=3
    
}


int main()
{
    //1. static
    for(int x =0; x <3; x++)
        fun();

    //another function of static means that the variable cann't be visited from another file

    //2. cin
    int input_var = 0;
    do{
        cout <<"Enter the number (-1 = quit):";

        if(!(cin >> input_var)) // cin returns false if an input operation fails
        {
            cout<<endl;
            cout << "The wrong input" <<endl;
            //recover from bad input
            //clear the error
            cin.clear();
            //remove the incorrect characters from the stream
            cin.ignore(1024,'\n'); //if the count achieve to 1024 or the ignored ch is '\n'
                                   // this means ignore the characters before '\n'
        }

        cout <<"You entered:" << input_var <<endl;
        
    }while( input_var != -1);
        

    return 0;
    
}

