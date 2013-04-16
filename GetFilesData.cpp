//:GetFilesData.cpp
#include "GetFilesData.h"

// display all elements in the vector
void Display(Data db)
{
    for(Iter iter = db.begin(); iter != db.end(); ++iter )
    {
        cout<< iter->second.id <<','
            << iter->second.filename<<','
            << iter->second.owner
            <<endl;
        
    }
}

int GetFilesNumber(Data db,string s)
{
    //not check db is null
    return db.count(s);
    
}

void GetFilesData(Data db, string s)
{
   // include s ?
   // if(db.count(s)>0)
    //{
         // get the range for key s
        Range range = db.equal_range(s);
        
        for(Iter iter = range.first; iter != range.second; iter++)
        {
           cout<<iter->second.id <<','
                <<iter->second.filename<<','
                <<iter->second.owner
                <<endl;
        // need to talk, continue to do sth
        }

   //}
        
}


