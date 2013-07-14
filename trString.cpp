//
#include <iostream>
#include <string.h>
using namespace std;

class String
{
private:
    char *data;
public:
    String(const char *str = "w");
    String(const String &other);

    virtual ~String(void);
    
    String & operator=(const String &other);

    inline void print() {
        for(int i=0; i<strlen(data) + 1; i++)
            cout<<data[i];
        cout<<endl;
        
    }
    
};

String::~String(void)
{
    delete [] data;
    
}

String::String(const char *str)
{
    cout<< " constructor"<<endl;
    
    if(str == NULL)
    {
        data = new char[1];
        *data = '\0'; // '\0' means the tail of string
        
    }
    else
    {
        int length = strlen(str);
        data = new char[length + 1];
        strcpy(data, str);
    }
    
}

String::String(const String &other)
{
    cout << "copy constructor"<<endl;
    int length = strlen(other.data);
    data  = new char[length + 1];
    strcpy(data, other.data);
}

String & String::operator=(const String &other) // here should defined const type
{
    cout << "assignment operator"<<endl;
    
    if(this == &other)
        return *this;

    delete [] data;

    //
    int length = strlen(other.data);
    data = new char[length + 1];
    strcpy(data, other.data);

    return *this;
    
}

int main()
{
    String s;
    s.print();
    
    String str("hello");
    str.print();

    //copy constructor let us can pass value
    //to create str1, the compiler first creates a temp object str by invoking the string constructor,
    // then compiler uses the String copy constructor to initialize str1 as a copy of the temporary
    String str1 = str;
    str1.print();
    /*
    String *sp= new String;
    String str3(*sp);
    cout<<"str3"<<endl;
    
    str3.print();
    */

    //assignment operator
    String str2("world");
    str2.print();
    
    str2 = str;
    str2.print();
    
    
}

    
