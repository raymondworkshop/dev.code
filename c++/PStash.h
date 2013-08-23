//: C13:PStash.h
// Holds pointers instead of objects
#ifndef PSTASH_H
#define PSTASH_H

class PStash
{
    int quantity; //number of storage spaces
    int next;     // next empty space

    void** storage;// pointer storage
    void inflate(int increase);
public:
    PStash(): quantity(0), storage(0), next(0) {}
    ~PStash();
    int add(void* element);
    void* operator[](int index) const; //Fetch

    void* remove(int index); // remove the reference from the PStash
    int count() const 
    {
        return next;
        
    }
};
#endif // PSTASH_H ///:~
