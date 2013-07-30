//VectorCopy.cpp : wenlong
//Description: copy the elements in list to deque vector,
//             if the element is even, copy to one deque, if not,copy to another one
#include <iostream>
#include <list>
#include <deque>
#include <string>
using namespace std;


int main()
{
    list<int> ilist;
    deque<int> iEvenDeque, iOddDeque;

    int ival;
    //read ival and store it into list
    cout <<"Enter the integers:"<<endl;
    while(cin>>ival)
        ilist.push_back(ival);

    //copy them to suited deque
    for(list<int>::iterator iter=ilist.begin(); iter != ilist.end(); ++iter)
    {
        if(*iter % 2 == 0)
            //even
            iEvenDeque.push_back(*iter);
        else
            iOddDeque.push_back(*iter);
    }

    //output
    for(deque<int>::iterator iter = iEvenDeque.begin(); iter != iEvenDeque.end(); ++iter)
        cout<<*iter<<" ";
    cout<<endl;
    
    for(deque<int>::iterator iter = iOddDeque.begin(); iter != iOddDeque.end(); ++iter)
        cout<<*iter<<" ";
    cout<<endl;
    
    return 0;
}

