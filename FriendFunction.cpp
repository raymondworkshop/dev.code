//A friend function is declared by the class to have access to the class's private
// and protected members
//Friend functions are not considered class members

#include <iostream>
using namespace std;

class Point 
{
private:
    int i;
public:
    Point(void): i(0) {}
    void PrintPrivate() { cout <<i<<endl;}

friend void ChangePrivate (Point &);
};

void ChangePrivate (Point &j) { j.i++; }

int main()
{
    Point point;
    point.PrintPrivate();
    
    ChangePrivate(point);
    point.PrintPrivate();
    
}

    
