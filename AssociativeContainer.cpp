//AssociativeContainer.cpp: wenlong
//Description
#include <iostream>
#include <utility> // pair type
#include <vector>
#include <string>
using namespace std;

int main()
{
    pair<string, int> sipair;
    string str;
    int ival;
    vector< pair<string, int> > pvec;

    cout<< "Enter a string and an integer:" <<endl;
    while(cin >> str >> ival)
    {
        sipair = make_pair(str, ival);
        pvec.push_back(sipair);
    }

    return 0;
}

