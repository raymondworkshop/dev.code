//vector1.cpp: wenlong
//description: vector exercise
#include <iostream>
#include <string>
#include <vector>
#include <list>
using namespace std;


int main()
{
    //pointer array
    //words is an array, whose element are pointer
    char* words[] ={"stately", "plump", "buck", "mulligan"};
    size_t words_size = sizeof(words)/sizeof(char *);
    
    string sarray[] ={"stately", "plump", "buck", "mulligan"};
    list<string> string_list;
    list<string>::iterator string_list_iter = slist.begin();
    string_list.insert(string_list_iter, sarray+2, sarray+4);

    for(string_list_iter = slist.begin(); string_list_iter != slist.end(); ++string_list_iter)
        cout<< *string_list_iter<<", ";
    cout<<endl;

    //iterators may be invalidated after doing any insert or push operation on a vector or deque
    //for example, adding elements to a vector can cause the entire container to be relocated,
    //if the container is relocated, then all iterators into the container are invalidated
    vector<int> int_vec;
    vector<int>::iterator int_vector_iter = int_vec.begin();
    int word;
    while(cin>>word)
        int_vector_iter = int_vec.insert( int_vector_iter, word);

    int_vector_iter = int_vec.begin();
    //here, we can't define a variable like mid = ivec.begin() + ivec.size()/2
    // because entire container will be relocated
    while( int_vector_iter != int_vec.begin() + int_vec.size()/2 )
    {
        cout<<":"<<*int_vector_iter<<endl;
        if(*int_vector_iter == 3)
        {
            int_vector_iter = int_vec.insert(int_vector_iter, 2 * 3); //pointer the above element
            int_vector_iter += 2; // next element
        }else
            ++int_vector_iter; //next element
    }
    
    for( int_vector_iter = int_vec.begin(); int_vector_iter != int_vec.end(); ++int_vector_iter)
        cout<<*int_vector_iter<<",";
    cout<<endl;

    //get 1st element
    if(!int_vec.empty())
    {
        cout<<*int_vec.begin()<<endl;
        cout<<int_vec.front()<<endl;
        cout<<int_vec[0]<<endl;

        //delete the 1st element
        //ivec.pop_front(); //only used in list or deque
        //delete the last element
        int_vec.pop_back();
        
    }

    //another way to erase some element
    // int value = 3;
    //int *p = &value;
    // vector<int>::iterator int_vector_iter = find(ivec.begin(), ivec.end(), value) ;
    //if(int_vector_iter != ivec.end())
    //  ivec.erase(int_// vector_iter);
    
    // for( int_vector_iter = ivec.begin(); int_vector_iter != ivec.end(); ++int_vector_iter)
    //     cout<<*int_vector_iter<<",";
    // cout<<endl;

    // //Vector
    // //To support fast random access, vector elements are stored contiguous,
    // //So, if the program requires random access to elements, use a vector.
    // //list
    // //a list only needs to create the new element and chain it into the existing list
    // //So, if the program needs to insert or delete elements in the middle of the container, use a list
        
    return 0;
}

