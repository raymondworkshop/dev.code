// Inheritance and dynamic binding
#include <iostream>
using namespace std;

class Base
{
private:
    string isbn;
    
//A protected member may be accessed by a derived object but may not be accessed by general users of the type    
//derived class expects to visit price
protected:
    //string isbn;
    
    double price;
    
public:
    Base(const string &book ="hello", double p = 1.0):isbn(book),price(p) {}
    Base(const Base &) {}
    
    string book() const {cout<<"Base"<<endl; return isbn;}
    
    //return total sales price for a specified isbn
    // a base class should define as virtual any function that a derived class will need to redefine
    // derived classes will override and apply different discount
    virtual double NetPrice(int n) const  { cout<<"Base NetPrice"<<endl; return n * price;}

    //Base should have virtual deconstructor;
    //Whwen we delete Base pointer,
    //it can run the related deconstructor (based on Derived)
    // based on the object the pointer points to 
    //E.x. when we use a pointer of Base class to delete a derived object,
    //the derived deconstructor is called
    virtual ~Base() {} // virtual deconstructor
    
};

//Function: discount when a specified number of copies of same book are sold
// the discount is expressed as a fraction used to reduce the normal price
class Derived : public Base
{
private:
    int min; // minimum purchase for discount to apply
    double discount;
public:
    Derived( double d=0.2, int m = 5): discount(d), min(m){}
    Derived(const string &book, double p, int m=0, double d=0.0): Base(book, p),min(m),discount(d){}

    string book() const {cout<<"Derive"<<endl;}
    
    
    //redefine base version so as to implement bulk purchase discount policy
    double NetPrice(int i ) const;

    ~Derived() {}
    
};

class pureVirtual: public Base()
{
 public:
    // define a virtual as pure indicates that  the function provides an interface
    // for subsequent types to overide but the viersion in this class will never be called
    // means user will not be albe to create objects of type pureVirtual;
    double NetPrice(int) const = 0; 
    
}


//each derived object can access the public and protected members (like price) of its base class
//as if those members were members of the derived class itself
double Derived::NetPrice(int cnt) const 
{
    cout<<"Derived NetPrice"<<endl;
    
    if(cnt >= min)
        return cnt * (1 - discount) * price;
    else
        return cnt * price;
}


//
void Print(const Base &Item, int n)
{
    cout<<"ISBN:" << Item.book() //call Base::book
        <<"\tnumber sold:" << n
        <<"\t total price:" << Item.NetPrice(n) //virtual call, is resovled at run time
        <<endl;
        
}

    
int main()
{
    //1. virtual and  protected member
    // 1) derived class only can visit protected member in base class through derived object,
    // derived class cannot vist protected member in base class through base object
    // like Derived class
    // 2) if there is no redefination virtual function in derived class, then it will use the version in base class
    // 3) once a function is declared as virtual in a base class it remains virtual,
    //    nothing the derived classes do can change the fact that the function is virtual

    //2. dynamic binding
    // 1)two conditions i) only member functions that are specified as virtual can be dynamically bound
    //                  ii) the call must be made through a reference or a pointer to a base-class type.
    //                  Virtuals are resolved at run time only if the call is made through a reference or pointer

    // 2) i) If the function called is nonvirtual, then regardless of the actual object type,
    //       the fuction that is executed is the one defined by the base type;
    //    ii) If the function is virtual,
    //       then  then the decision as to whhich function to run is delayed until run time
    //       E.X. function with an Base reference parameter
    //        void Print(const Base &item, int n);
    Base item("world");
    //even if Derived defined its own version of the book function,
    //this call would call the one from Base;
    // the call of book function is resolved at compile time to Base::book
    Print(item, 10);// call Base::book and Base::NetPrice

    Derived bulk;
    Print(bulk, 10); //call Base::book and Derived::NetPrice
    //    iii)overriding the virtual mechanism,
    //        when a derived-class virtual calls the version from the base.
    //        Only code inside member functions should ever need to use the scope operator(like Base)
    //        to override the virtual mechanism
    Base *BaseP = &bulk;
    //   the code forces the call to NetPrice to be resolved to the version defined in Base
    //   The call will  be resolved at compile time
    double d0 = BaseP->NetPrice(23);
    cout<<d0<<endl; //11.5
    
    double d = BaseP->Base::NetPrice(42);
    cout<<d<<endl; // 42
    
    //Derived *p;
    //BaseP->book(); // ok, this is a Base pointer
    BaseP->book(); //Base, actually
    
    
    //3. public, private, and protected inheritance
    //   1)in protected inheritance, the public and protected members of the base class
    // are protected members in the derived class;
    //    In private, all are private;
    // The above controls the access that users (object and members) of the derived class have
    //   Notice i) the difference between object access (public) and members access (public and protected)
    //          ii) object access only see the status in its class
    //              (private inheritance, all members in Base become private in Derived)

    //   2)Frienship is not inherited
    //   For static member, if the member is accessible(not private), we can access
    //   the static member either through the base or derived class

    //4. derived to base Conversions
    //   1) converting a derived object to a base-type reference
    //       When we pass an object of derived type (like bulk) to a function (like print),
    //   expecting a referene to base, the reference (Base &item) is bound directly to that object (bulk),
    //   The is actually a reference to bulk object, the object itself is not copied and the conversion
    //   doesn't change the derived-type object in any way. It remains a derived-type object
    Derived bulk4;
    Print(bulk4, 10); // Print(const Base&, int)
    
    //   2) using a derived object to initialize or assign to a base-type object
    //      In this case, we are actually calling a function: a constructor or an asignmetn operator
    // use constructor Base::Base(const Base&)
    Base item4(bulk4); // bulk4 is sliced down to its Base portion
    // use assignment operation Base::operator = (const Base&)
    // item4 = bulk4;
    
    //   3) no automatic conversion from the base class to a derived class

    //5. derived constructors and copy control
    //   Each derived constructor initializes its base class + its own data members
    //   Only an immediate base class can be initialized
    Derived bulk5("0-201-82", 5, 5, 0.2);
    Print(bulk5,5);
    //6. copy constructors
    //   Classes that contain only data members of class type or built-in types other than pointers
    //   usually can use the synthesized operations;
    //   Classes with pointer members often need to define their own copy control to manage these members
    
    //7. 
    Base item7;
    Derived bulk7;
    Base *bp1 = &item7;
    Base *bp2 = &bulk7;
    //process:  1)the pointers are Base, so compiler look in Base to see if bp1,bp2 are defined
    //          2)then look for the function (like NetPrice),
    //          3) if the function is virtual and the call is through a reference or pointer,
    //             then compiler generates code to determine which version to run
    //             based on the dynamic type of the object;
    //             Otherwise, compiler g enerates code to
     bp1->NetPrice(10); //virtual call Base::NetPrice run time
    bp2->NetPrice(10); //virtual call Derived::NetPrice run time
    
    //8) pure virtual functions
    // we want user couldn't create such objects at all
              
}


