#include <iostream>
#include <string>
#include <vector>
using namespace std;

// how many 1s in an interger's binary expression
int numberof1(int i)
{
    int count = 0;
    while(i)
    {
        if (i & 1)
            count +=1;
        i= i>>1;
        
    }

    return count;
            
}


char *strcpy(char *strDest, const char *strSrc)
{
    if(strDest == NULL || strSrc == NULL)
        return NULL;
    if(strDest == strSrc)
        return strDest;
    char *temp =strDest;
    while((*strDest++ = *strSrc++) != '\0')
    
    return temp;
    
}


int main()
{
    int i = 1;
    int j = 2;

    i = i+ j;
    j = i -j;
    i = i - j;

    cout<< i <<","<<j<<endl;

    int x = 65536;
    cout << x << endl;
   
    string s;
    
    getline(cin, s);
    cout<< s<< endl;
    
    char ch;
    string::size_type y = s.size() -1;
    //cout<<y<<endl;
    
    for(string::size_type x = 0; x < s.size()/2; x++,y--)
    {
        // cout<<s[x]<<endl;
        
        ch = s[x];
        s[x]=s[y];
        s[y]=ch;
        
    }
    cout<<s<<endl;

    cout<<numberof1(10)<<endl;

    char ch1[]="wenlongz";
    char ch2[9] ={};
        
    strcpy(ch2,ch1);
    cout<<ch2<<endl;

    /*
    vector<int> ivec;
    
    int num;
    while(cin>>num)
        ivec.push_back(num);

    vector<int>::iterator first, last;
    for(first=ivec.begin(),last=ivec.end() -1; first<last; ++first,--last)
        cout<< *first + *last <<endl;
    */
    string word("WORLD heLLO");
    //cin>>word;
    vector<string> svec;
    vector<string>::iterator iter;

    svec.push_back(word);
   
    
    for(iter=svec.begin(); iter!= svec.end(); ++iter)
    {
        cout<<*iter<<",";
        
        for(vector<string>::size_type index=0; index<(*iter).size(); ++index)
            (*iter)[index]=tolower((*iter)[index]);
        cout<<*iter<< " ";
    }
    
            
    return 0;
    
}

