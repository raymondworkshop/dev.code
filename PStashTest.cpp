//: C13:PStashTest.cpp
// Test of pointer stash
#include "PStash.h"
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main()
{
    PStash intStash;
    // 'new' works with built-in types,too
    for(int i = 0; i < 25; i++)
        intStash.add(new int(i)); // store the int object in heap and initialize it with i
    for(int j = 0; j< intStash.count(); j++)
        cout << "intStash[" << j << "] = "
             << *(int*)intStash[j] <<endl;
    //clean up
    for(int k = 0; k < intStash.count(); k++)
        delete (int*)intStash.remove(k);

    ifstream in ("PStashTest.cpp");
    PStash stringStash;
    string line;

    while(getline(in, line))
        stringStash.add(new string(line));

    //print out
    for(int u = 0; stringStash[u]; u++)
        cout << "stringStash[" << u << "] = "
             << *(string*)stringStash[u] << endl;
    //clean up
    for(int v = 0; v < stringStash.count(); v++)
        delete (string*)stringStash.remove(v);
    
} ///:~

