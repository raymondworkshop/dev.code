//Erase.cpp: muyun
//Description: erase() function
//Define:  iterator erase(iterator );
//         iterator erase(iterator first, iterator last);
#include <iostream>
#include <list>
#include <vector>
using namespace std;

typedef list<int> Ilist;
typedef list<int>::iterator IlistIter;
typedef vector<int> Ivec;
typedef vector<int>::iterator IvecIter;

int main()
{
    Ilist ilist;
    for( size_t i = 1; i != 6; ++i)
        ilist.push_back(i);

    /*
    for(IlistIter iter=ilist.begin(); iter != ilist.end(); ++iter)
    {
        //if we do like this,
        //iter has been erased and doesn't point any element,
        //so it only erase the first even element
        //Therefore, before we delete iter, give it a backup, like this
        //ilist.erase(iter++)
        if (*iter % 2 == 0)
           ilist.erase(iter); 
        
    }
    */

    for(IlistIter iter=ilist.begin(); iter != ilist.end();)
    {
        cout <<*iter<<endl;
        if (*iter % 2 == 0)
            ilist.erase(iter++); //backup the iter
           // in list container, the below is also ok
           //iter = ilist.erase(iter);
        else
            ++iter;
            
    }
    
    for(IlistIter iter = ilist.begin(); iter != ilist.end();++iter)
        cout<<*iter<<endl;
    cout<<endl;

    Ivec ivec;
    for(size_t i = 0; i != 6; ++i)
        ivec.push_back(i);
    
    for(IvecIter iter=ivec.begin(); iter != ivec.end(); )
    {
        cout<<*iter<<endl;
        
        if(*iter % 2 == 0)
            //in vector, there is no gap between elements,
            //so, after erasing one element, the following elements will move ahead
            //Therefore, the current index iter will become the index of the following element
            ivec.erase(iter); 
        else
            ++iter;
    }

    for(IvecIter iter=ivec.begin(); iter != ivec.end();++iter)
        cout<<*iter<<endl;
    cout<<endl;
    
    return 0;
}


