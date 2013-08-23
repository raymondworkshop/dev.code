//
#include <iostream>
using namespace std;

class Date {
    int month;
    mutable int day;
    
public:
    Date(int mn, int dy);
    
    int getMonth() const; // a read only function,
                          //it doesnot modify the object for which it is called
    void setMonth(int mn);
};

Date::Date(int mn, int dy) : month(mn),day(dy) {}

int Date::getMonth() const 
{
    //month++; //error, const member function
    
    cout<< month<<endl;
    
    day++;
    cout<<day<<endl;
    
}

void Date::setMonth(int mn)
{
    month = mn;
}


int main()
{
    Date MyDate(10,4);
    const Date BirthDate(1,19);
    
    //MyDate.setMonth(4); //ok
    MyDate.getMonth();
    
    BirthDate.getMonth();//ok
    
    //BirthDate.setMonth(4); // error

    //mutable: specify that a particular data member may be changed inside a const object
    //BirthDate.setMonth()
}

