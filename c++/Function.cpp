// function call
#include <iostream>
#include <vector>
#include <string>
using namespace std;


vector<int>::const_iterator FindVal(vector<int>::const_iterator beg, vector<int>::const_iterator end, int value, vector<int>::size_type &count )
{
        // res will hold first occurrence, if any
        vector<int>::const_iterator res = end;
        count = 0;
        for(; beg != end; ++beg)
        {
            
            if(*beg == value)
            {   // remember first occurrence of value
                if(res == end)
                    res = beg;
                
                ++count;
            }

                     
        }

        return res;

}
//compare the length
//Because the parameters are const references,
//isShorter maynot use the references to change the arguments
//Also, if there is no const, no-const references is only compatible with no-const object
// inline removes the run-time overhead of making isShorter a function
inline string isShorter(const string &s1, const string &s2)
{
       
    return s1.size()<s2.size() ? s1 : s2;
    
}

int main()
{
    //1. pointer parameters
    // If we want to modify the argument's value in caller through caller function,
    // we should use reference parameters
    //2. reference parameters
    // 1) using reference parameters to return aditional results to the calling function
    //    Functions can return only a single value
    // The function returns an iterator that refers to the first occurrence of value and
    // the reference parameter occurs contains the count of occurrence
    
    vector<int> ivec;
    vector<int>::iterator iter;

    int num;
    while(cin>>num)
        ivec.push_back(num);
    //for( iter=ivec.begin(); iter < ivec.end(); ++iter)
    //  cout<< *iter <<endl;
    
    //want to know an iterator refering to 4 and the count of its occurrence
    vector<int>::size_type ctr = 0;
    // Here ctr stores the count of the occurrence
    vector<int>::const_iterator f = FindVal(ivec.begin(),ivec.end(),4, ctr);
    cout <<*f<<endl;
    cout << ctr<<endl;

    
    //3. Using references to avoid copies
    // if the only reason to make a parameter a reference is to avoid copying the argument
    // the parameter should be const reference
    string s3("Hello,world");
    string s4("wenlong zhao");
    
    cout<<isShorter(s3,s4)<<endl;
        
    
     return 0;
}


