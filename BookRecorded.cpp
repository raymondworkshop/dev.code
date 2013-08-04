//BookRecorded: wenlong
//Description:  recored the list of read book and toread book
#include <iostream>
#include <string>
#include <vector>
#include <set>
#include <cstdlib>
#include <ctime>
using namespace std;

typedef vector<string> StringVec;
typedef StringVec::iterator StringVecIter;
typedef set<string> StringSet;
typedef StringSet::iterator StringSetIter;

int main()
{
    //the book list
    string book;
    StringVec books; //books records all books
    cin>>book;
    books.push_back(book);
    cin.clear();
    
    StringSet readed_books; 
    
    bool time_over = false;
    
    srand(time(0)); //init rand
    string answer;
    
    while(!time_over && !books.empty())
    {
        int i = rand() % books.size();
        string book_name = books[i];
        
        cout<<"book name:"<< book_name <<endl;

        //put it in set
        readed_books.insert(book_name);
        //erase the book from vector
        books.erase(books.begin() + 1);
        //TODO, seems that there is no input for answer
        cout<<"Did you read it? (Yes/No)" <<endl;
        cin>>answer;
        //cout<<answer<<endl;
        if (answer[0] == 'n' || answer[0] == 'N')
        {
            readed_books.erase(book_name);
            books.push_back(book_name);
            
        }

        cout<<"Time Over? (Yes/No)" <<endl;
        cin>>answer;
        //cout<<answer<<endl;
        
        if (answer[0] == 'y' || answer[0] == 'Y')
        {
            time_over = true;
            
        }
        
    }
    
    if (time_over)
    {
       for(StringVecIter iter=books.begin(); iter != books.end(); ++iter)
          cout << *iter <<endl;


       for(StringSetIter iter=readed_books.begin(); iter != readed_books.end(); ++iter)
           cout <<*iter<<endl;

    }
    
}


