//: C06: Stash2.h
// With constructors & destructors
// C++ let users to define new data type, which makes compilers to check this data type to make sure the security.
// Also, let compiler create constructor and destructors to initialize and delte the object auto
#ifndef STASH2_H
#define STASH2_H

class Stash 
{
    int size;     // size of each space
    int quantity; // number of storage spaces
    int next;     // next empty space

    unsigned char* storage; // dynamically allocated array of bytes
    void inflate (int increase);

public:
    Stash(int size);
    Stash (int size,int initQuantity); // can assign the memory quantity
    
    ~Stash();
    int add(void* element);
    void* fetch(int index);
    int count();
        
};
#endif // STASH2_H ///:~
