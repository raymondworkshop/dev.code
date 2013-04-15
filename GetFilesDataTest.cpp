//:GetFilesDataTest.cpp
// test
#include "GetFilesData.h"
using namespace std;

int main()
{
    EntriesData d1,d2,d3,d4;
    d1.id = 1;
    d1.filename = "f1";
    d1.owner = "w1";

    d2.id = 2;
    d2.filename = "f4";
    d2.owner = "w2";

    d3.id = 3;
    d3.filename = "f3";
    d3.owner = "w3";

    d4.id = 4;
    d4.filename = "f4";
    d4.owner = "w4";

    Data db;

    db.insert(make_pair(d1.filename,d1));
    db.insert(make_pair(d2.filename,d2));
    db.insert(make_pair(d3.filename,d3));
    db.insert(make_pair(d4.filename,d4));
    
    Display(db);

    int n = 0;
    n = GetFilesNumber(db, "f4");
    cout<<n<<endl;

    if (n>0){

    GetFilesData(db, "f4");

    }
}

