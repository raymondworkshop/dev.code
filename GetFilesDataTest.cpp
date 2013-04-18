//:GetFilesDataTest.cpp
// test
#include "GetFilesData.h"
using namespace std;

int main()
{
    //EntriesData d1,d2,d3,d4;

    string str = "1,f1,w1;2,f2,w2;3,f3,w3;4,f2,w4";

    Data db,db1;
    db1=StoreData(db, str, ";");
    /*
    for(Iter iter = db1.begin(); iter != db1.end(); ++iter )
    {
        cout<< iter->second.id <<','
            << iter->second.filename<<','
            << iter->second.owner
            <<endl;
        
    } */

    Display(db1);
   
    int n = 0;
    n = GetFilesNumber(db1, "f2");
    cout<<n<<endl;

    if (n>0){

    GetFilesData(db1, "f2");

    }
 
}

