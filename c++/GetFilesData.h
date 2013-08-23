//: GetFilesData.h
// Get file list based on keywords
#ifndef GETFILES_H
#define GETFILES_H
#include <stdio.h>
#include <iostream>
#include <map>
#include <string>
#include <sstream>
#include <vector>
using namespace std;

struct EntriesData
{
    string id;
    string filename;
    string owner;
};

typedef std::multimap<string,EntriesData> Data;
typedef Data::iterator Iter;
typedef pair<Iter,Iter> Range;
typedef vector<string> Str;
typedef Str::iterator StrIter;

void Display(Data d);
int GetFilesNumber(Data db,string s);
void GetFilesData(Data db,string s);
Data StoreData(Data db,string ss, string s);
Str split(string ss, string s);
string join(Str str, string s);

#endif //GETFILES_H
    
