//AssociativeContainer.cpp: wenlong
//Description
#include <iostream>
#include <utility> // pair type
#include <vector>
#include <string>
#include <map>
#include <set>
using namespace std;

typedef pair<string, int> StringPair;
typedef vector< StringPair > StringPairVec;
typedef map< int, unsigned int> IntegerMap;
typedef map< int, unsigned int>::iterator IntegerMapIter;

int main()
{
    
    StringPair str_pair;
    string str;
    int ival;
    StringPairVec str_pair_vec;
    /*
    cout<< "Enter a string and an integer:" <<endl;
    while(cin >> str >> ival)
    {
        str_pair = make_pair(str, ival);
        str_pair_vec.push_back(str_pair);
    }
    */
    /*
    //map
    IntegerMap integer_count;
    int integer;

    //TODO: this seems that it doesn't work  
    cout<< "Enger the integers:"<<endl;
    while(cin >> integer)
    {
        cout<<integer<<endl;
        //++integer_count[integer];
        //another insert value
        pair< map<int, unsigned int>::iterator, bool>  ret = integer_count.insert(make_pair(integer, 1));
        if(!ret.second)
            ++((ret.first)->second);
        
    }
    
    //get the value of key 3
    int occur = 0;
    IntegerMapIter iter = integer_count.find(3);
    if (iter != integer_count.end())
        // find first then get it,
        //or, if this key 3 doesn't exist in map, it will insert this key
        occur = iter->second;
    cout<<"3:"<<occur<<endl;

    //erase 3 from this map
    int removal_integer = 3;
    if(integer_count.erase(removal_integer))
        cout<<"ok:"<< removal_integer << " removed\n";
    else
        cout<<"oops:"<< removal_integer << "not found\n";
        
    for(IntegerMapIter integer_map_iter = integer_count.begin(); integer_map_iter != integer_count.end(); ++integer_map_iter)
        cout<<integer_map_iter->first<<":"<<integer_map_iter->second<<endl;
    
    */
    //set
    //the key of set is const
    vector<int> ivec;
    for(vector<int>::size_type i=0; i != 10; ++i)
    {
        ivec.push_back(i);
        ivec.push_back(i);
    }
    set<int> iset (ivec.begin(), ivec.end());
    cout <<ivec.size()<<endl;
    cout <<iset.size()<<endl;

    iset.insert(10);
    int value = 7;
    set<int>::iterator iter = iset.find(value);
    if(iter != iset.end())
        cout<<*iter<<endl;

    if(iset.count(value))
        cout<<*iter<<endl;
            
    return 0;
}

