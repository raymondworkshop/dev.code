//: GetFilesData.h
// Get file list based on keywords
#ifndef GETFILES_H
#define GETFILES_H
#include <stdio.h>
#include <iostream>
#include <map>
#include <string>
using namespace std;
   
struct EntriesData
{
    int id;
    string filename;
    string owner;
};

typedef std::multimap<string,EntriesData> Data;
typedef Data::iterator Iter;
typedef pair<Iter,Iter> Range;

void Display(Data d);
int GetFilesNumber(Data db,string s);
void GetFilesData(Data db,string s);

#endif //GETFILES_H
    
