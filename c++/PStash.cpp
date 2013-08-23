//: C13:PStash.cpp
// pointer Stash definitions
#include "PStash.h"
#include <iostream>
#include <cstring>  // the header file defines several functions to manipulate C strings and arrays
using namespace std;

int PStash::add(void* element)
{
    const int inflateSize = 10;
    if(next >= quantity)
        inflate(inflateSize);
    storage[next++] = element; // storage pointer instead of the object copy
    return (next -1); //Index number
}

PStash::~PStash()
{
    delete []storage;
    
}

// operator overloading replacement for fetch
void* PStash::operator[] (int index) const 
{
    if(index >= next)
        return 0; // to indicate the end

    // produce pointer to desired element
    return storage[index];
}

void* PStash::remove(int index)
{
    void* v = operator[](index);
    // remove the pointer
    if(v != 0) storage[index] = 0;
    return v;
}

void PStash::inflate(int increase)
{
    const int psz = sizeof(void*);
    void** st = new void*[quantity + increase];
    memset(st, 0, (quantity + increase) * psz); // memset Sets the first (quantity + increase) * psz bytes of the block of memory pointed by st to 0.
    memcpy(st, storage, quantity * psz);  //memcpy copies the value of *psz from storage to st

    quantity += increase;
    delete []storage; // old storage
    storage = st;    // point to new memory
            
}



