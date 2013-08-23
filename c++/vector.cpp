//vector lib
//The standard lib manages and stores the memeory
#include <iostream>
#include <vector>
#include <string>
using namespace std;

int main()
{
    // constructor
    // vector<int> ivec1;
    // vector<int> ivec2(ivec1);
    // vector<int> ivec3(10,-1); // 10 elements, each initialized to -1
    // vector<string> svec(10,"hi");

    // for efficience, add the element dynamicly
    
    vector<int> ivec(10,1);

    for (vector<int>::size_type i =0; i != 10; ++i)
        ivec.push_back(i);
    
    /*for(vector<int>::size_type i =0; i != ivec.size(); ++i)
        cout<< ivec[i];

    cout<<endl;
    */
    
    int j = 0;
    vector<int>::iterator iter;
    // the below is wrong code
    // the vector size changes, so you can push_back the value to vector
    //for(iter = ivec.begin(); iter != ivec.end(); ++iter)
    //{
        // int n =j++;
        //ivec.push_back(2);
    //    *iter = 2;   
    // }
   
    for(iter = ivec.begin(); iter != ivec.end(); ++iter)
        cout<< *iter; // * is dereference operator

    cout<<endl;
    
    // read
    vector<int> ivec;
    vector<int>::iterator iter;
    int num;
    
    while(cin >> num)
        ivec.push_back(num); //CTRL+ X is the end
    // here , +1, -1 is +(-) vector int's size_type
    for(iter = ivec.begin(); iter<ivec.end() -1; ++iter)
        cout<< *iter + *(iter+1)<<endl;
    

    vector<int>::iterator first, last;
    for(first =ivec.begin(),last=ivec.end() -1; first<last; ++first, --last)
       {
           //cout <<"first:"<<*first<<endl;
           //cout <<"last:"<<*last<<endl;
           // the first + the last one
           cout << *first + *last <<","<<endl;
           
       }
    
    if(first == last)
    {
        cout<<"The center element:"<< *first <<endl;
        
    }
    
    
    vector<string> svec;
    vector<string>::iterator iter;
    
    string word;
    cin>>word;
    svec.push_back(word);

    vector<string>::size_type cnt = 0;
    
    for(iter = svec.begin(); iter < svec.end(); ++iter)
    {
        cout<< *iter <<endl;
        //for each word
        
        for(vector<string>::size_type index =0; index != (*iter).size(); ++index)
            // toupper deals with char
            (*iter)[index]=toupper((*iter)[index]);
        
        cout<< *iter<<" ";
        
        ++cnt;
        if (cnt % 8  == 0)
            cout<<endl;
          
    }
    //return 0;
}

    
