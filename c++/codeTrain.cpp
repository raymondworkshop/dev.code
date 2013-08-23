#include <iostream>
#include <string>
using namespace std;

class Base
{
   private:
        double price;
   protected:
        string book;
   public:
    // Base(){}
    
        Base(double d=0.0, const string &b=""):price(d), book(b){}
        Base(const Base &other)
        {
            cout<<"copy base constructor"<<endl;
            book = other.book;
            price = other.price;
        }

        virtual void print() {cout<<"Base virtual print"<<endl; }
        virtual void print(size_t n , const string & book);
    
    void show() {cout<<"base show"<<endl;cout<<book <<" "<<  price <<endl;}
        virtual ~Base() { }
};

void Base::print(size_t n, const string &book)
{
   cout<< "base 2nd print" <<endl;
   cout<<book<<" "<< n * price <<endl;
}

class Derived: public Base
{
private:
       size_t derived_price;
public:
    // Derived(){}
    
        Derived(size_t m, const string &book):Base(m,book) , derived_price(m) {}
        Derived(const Derived &other)
        {
            derived_price = other.derived_price;
            
        }
     
        void print() {cout <<"Derived virtual print function" <<endl;}
        void print(size_t i, const string &book);
    
        void show() {cout<<book<<" "<<  derived_price << endl;}
        ~Derived() {}
};

void Derived::print(size_t i, const string &book)
{
    cout<<"Derived 2nd print"<<endl;
    cout<<book<<" "<< i * derived_price << endl;
}

int main()
{
   // base ...
   Base  base(1, "hello");

   base.print(2, "hello");

   Derived bulk(2, "world");
 
   bulk.print(3, "world");
   
  // copy constructor
       Base base1 = base;
       base.show();
   base1.show();
   //assign operator

   //virtual
   Base *p = new Derived(3,"hello world");
   p->print();
   
   return 0;
}
