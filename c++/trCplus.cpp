#include <iostream>
#include <string>
using namespace std;

//macro
/*
#define YEAR (365*24*60*60)UL

#define min(X,Y) ((X)<(Y) : (X) ? (Y))

//function pointer
void (*f)()
//function return pointer
    void *f()
//const pointer
    int *const p;
//a pointer points to const
const int *p;
// a const pointer points to const
const int *const p
*/
/*
int *p;
int **p;

int array[10];
int *array[10];

int (*array)[10];

int (*f)(int);

int (*f)(int)[10];


*/

int main()
{
    
// pointer array,an array, whose elements all pointer
int *ptr[2]; // p is an array, whose elements are pointer, 3 int pointer
 int p1=5, p2=6;
 ptr[0] = &p1;
 ptr[1] = &p2;

 cout <<*ptr[0]<<endl;
 cout <<*ptr[1]<<endl;
 
 //array pointer
 int test[3]={1,2,3};
 int (*p)[3];// p is a pointer, pointing to a 4-element array

 p = &test;

 cout<<(*p)[2]<<endl; //3
 
  return 0;
 
     
}


