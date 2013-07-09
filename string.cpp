// string, vector and bitset lib
#include <iostream>
#include <string>
using namespace std;

int main()
{
    //string type supports variable-lengh character strings
    /*
    string word;
    // read until end-of-file, writing each word to a new line
    while(cin>>word)
    {
        cout<<word<<endl;
        cout<<word.size()<<endl;
        }
    
    string line;
    while(getline(cin,line)) //getline keep the content until '/n'
        cout<<line<<endl;

    */
   
    //consructor string s2(s1); => s2 initialize s1's copy
    string st("I am wenlong");
    if(st.size() != 0)
    {
        cout<< "The size of " << st <<"is "<<st.size()<<endl;
        
    }

    string st1("Hello");
    st += st1;
    
    cout << st <<endl;
   
    // the type of size function is string::size_type
    // The reason:
    //1) This definition (like unsigned, twice than int)  can guarantee the enough space to store the string
    //2) independent of the machine

    for(string::size_type i = 0; i< st.size(); i++)
        cout<<st[i] <<endl; // print each char
    

    // remove the punctuation in the input string
    string input, output;
    getline(cin,input);
    cout<< input <<endl;
    for(string::size_type i = 0; i<input.size(); i++)
        {
            //cout<<input[i]<<endl;
            if (!ispunct(input[i]))
            {
                
                //cout<<input[i]<<endl;
            
                output += input[i];
            }
            
         }
    
    cout << output << endl;
        
    return 0;
    
}


