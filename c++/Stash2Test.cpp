//: C06:Stash2Test.cpp
// Constructors & destructors
#include "Stash2.h"
#include <fstream> // fstream provides an interface to rad and write data from files
#include <iostream>
#include <string>
using namespace std;

int main()
{
    Stash intStash(sizeof(int));  // Stash intStash and Stash::Stash

    for(int i = 0; i < 10; i++)
        intStash.add(&i);

    for(int j = 0; j < intStash.count(); j++)
        cout << "intStash.fetch(" << j << ") = "
             << *(int*)intStash.fetch(j)
             << endl;

    // holds 80-character strings
    const int bufsize = 80;
    Stash stringStash(sizeof(char) * bufsize, 100);
    ifstream in("Stash2Test.cpp");
    string line;

    while(getline(in,line))
        stringStash.add((char*)line.c_str());
    int k = 0;
    char* cp;

    while((cp = (char*)stringStash.fetch(k++))!=0)
        cout << "stringStash.fetch(" << k << ") = "
             << cp << endl;

} ///:~

