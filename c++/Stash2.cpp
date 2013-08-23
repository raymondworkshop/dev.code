//: C06: Stash2.cpp
// Constructors & destructors
#include "Stash2.h"
//#include "../require.h"
#include <iostream>
#include <cassert>  //cassert defines one macro that can be used as a standard debugging tool
using namespace std;
const int increment = 50;

Stash::Stash(int sz)
{
    size = sz;
    quantity = 0;
    storage = 0;
    next = 0;
    
}

Stash::Stash(int sz, int initQuantity)
{
    size = sz;
    quantity = 0;
    next = 0;
    storage = 0;
    inflate(initQuantity);
    
}

int Stash::add(void* element)
{
    if(next >= quantity) //Enough space left?
        inflate(increment);

    // copy element into storage
    // starting at next empty storage
    int startBytes = next * size;
    unsigned char* e = (unsigned char*)element;

    for(int i =0; i < size; i++)
        storage[startBytes + i] = e[i];  //compiler doesnot the type, so we ahve to copy the bye one by one
    
    next++;
    return(next -1);
                
}

void* Stash::fetch(int index)
{
    if (index >= next)
        return 0; // to indicate the end

    //produce pointer to desired element
    return &(storage[index * size]);
    
}

int Stash::count()
{
    return next; // number of elements in CStash

}

void Stash::inflate(int increase)
{
    int newQuantity = quantity + increase;
    int newBytes = newQuantity * size;
    int oldBytes = quantity * size;

    unsigned char* b = new unsigned char[newBytes];
    for(int i = 0; i < oldBytes; i++)
        b[i] = storage[i]; // copy old to new

    delete [](storage);// old storage
    storage = b; // point to new memory
    quantity = newQuantity;
        
}

Stash::~Stash()
{
    if(storage != 0) 
    {
        cout << "freeing storage" << endl;
        delete []storage;
        
    }
    
} ///

