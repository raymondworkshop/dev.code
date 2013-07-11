//class
#include <iostream>
#include <string>
using namespace std;

class Screen
{
public:
    typedef string::size_type index;        
    explicit Screen(index h, index w, const string &cntnts);
        
    char get() const {return contents[cursor];} ;
    char get(index i, index wd) const;
    
    index GetCursor() const;
    
    Screen &move(index r, index c);
    Screen &set(char);
    Screen &display(ostream &os);
    
private:
    string contents;
    index cursor;
    index height, width;    
};

Screen::Screen(index h, index w, const string &cntnts):
    contents(cntnts), cursor(0), height(h), width(w) {}

char Screen::get(index r, index c) const 
{
    index row = r * width;
    return contents[row + c];
    
}

inline Screen::index Screen::GetCursor() const 
{ return cursor;}

//
//when we need to refer to the object as a whole rather than to a member of the object
// we can use this pointer to return a reference to the object
Screen &Screen::set(char c)
{
    contents[cursor] = c;
    return *this; 
    
}
Screen &Screen::move(index r, index c)
{
    index row = r * width;
    cursor = row + c;
    return *this;
}
Screen &Screen::display(ostream &os)
{
    os<<contents<<endl;
    return *this;
    
}

class Sales
{
private:
    string isbn;
    int unit;
    double revenue;
    
public:
    //A better way:using a constructor initializer
    //1)more efficiency: A data member is initialized and assigned when it
    // could have been initialized directly
    //2) More important than the efficiency issue is the fact that some data
    //members must be initialized, like an initializer for any const or reference member
    // that does not have a default constructor
    // Also, a default argument ("" in default constructor) for book is the empty string
    Sales(const string &book = ""):isbn(book),unit(1),revenue(0.0){};
    //default constructor is cin
    Sales(std::istream &is);
    // It is always right to provide a default constructor if other constructors are being defined
    // Ordinarily the initial values given to he members in the default constructor should indicate
    //that the object is "empty"
    //Sales(){};  
      
    /*
    //assignto to them inside the constructor body
    Sales(const string &book)
    {
        // isbn is initialized from string default constructor, isbn=""
        // and unit, revenue don't initialize
        // The initial value of members depend on the scope of the object:
        //At local scope those members are uninitialized,
        //At global scope they are initialized to 0
        cout<< isbn <<","<< unit <<","<<revenue <<endl;
        cout<<"world"<<endl;
        //We initialized the members through assigining to them inside the constructor body
        isbn = book;
        unit = 1;
        revenue = 0.1;
    };
    */
    void print();

friend Sales add(const Sales &, const Sales &);
        
};

 void   Sales::print()
    {
        cout<< isbn <<","<< unit<<","<<revenue<<endl;
        
    }

//friend
Sales add(const Sales &obj1, const Sales &obj2)
{
    Sales temp;
    temp.isbn = obj1.isbn;
    temp.unit = obj1.unit + obj2.unit;
    temp.revenue = obj1.revenue + obj2.revenue;

    return temp;
    
}

int main()
{
    //1.
    Screen myScreen(2,3,"aaaaaaaaaaa");
    // the statement to be equivalent to
    // myScreen.move(4.0);
    // myScreen.set('#'); because of this pointer
    myScreen.move(2,1).set('#').display(cout);


    //2.constructor initializer
    // Initialization happens before the computation phase begins.
    // Data members of class type are always initialized in the initialization phase,
    //regardless of whether the member is initialized explicitly in the constructor initializer list
    Sales sale("hello");
    sale.print();
    Sales sale1;
    sale1.print();
    //TODO: Here if the default is the cin, then?
    //Sales sale2(cin);
    //sale2.print();
    
    //3.The Synthesized default constructor
    //If a class defines one constructor, the compiler will not generate the default constructor
    //Classes should usually define a default constructor,because
    // 1) If the class has no default constructor, then the class may not be used in these contexts
    //  E.X p531 in c++ primer
    //

    //4. friend
    Sales sale2 =add(sale, sale1);
    sale2.print();
    
    return 0;
    
}

