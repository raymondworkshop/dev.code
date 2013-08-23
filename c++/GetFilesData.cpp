//:GetFilesData.cpp
#include "GetFilesData.h"

// display all elements in the container
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

string join(Str str, string delim)
{
    stringstream ss;
    
    StrIter iter = str.begin();
    ss << *iter++;
    
    for(; iter != str.end(); ++ iter)
    {
        ss << delim << *iter;
        
    }

    return ss.str();
}

Str split(string s, string pattern)
{
    string::size_type pos;
    Str result;
    s += pattern;
    int size = s.size();
    
    for (int i=0; i< size; i++)
    {
        pos = s.find(pattern, i);
        if(pos < size)
        {
            string ss = s.substr(i,pos-i);
            result.push_back(ss);
            i = pos + pattern.size()-1;
            
        }
    }
    return result;
}

Data StoreData(Data db,string s, string pattern)
{
    // like 1,f1,w1;2,f2,w2
    EntriesData d;
    
    Str result = split(s, pattern);
    for (int i=0; i< result.size(); i++)
    {  
        // cout<<result[i]<<endl;
         // like 1,f1,w1
        Str r = split(result[i],",");
        
        d.id = r[0];
        d.filename = r[1];
        d.owner = r[2];
            
        db.insert(make_pair(d.filename,d));
    }

    return db;
}

void GetFilesData(Data db, string s)
{
   // include s ?
   // if(db.count(s)>0)
    //{
    //It's better update the match function in map
    // for no-full-compatible function
    // KMP algorithm

    stringstream ss;
    // get the range for key s
    Range range = db.equal_range(s);
        
    for(Iter iter = range.first; iter != range.second; iter++)
    {
    // join function is better
       ss<<iter->second.id <<","
         <<iter->second.filename<<","
         <<iter->second.owner<<";";
            
      //  ss = join(iter->second,";");
    }
    
    //2,f2,w2;4,f2,w4;
    cout<<ss.str()<<endl;
    
   //}
}


