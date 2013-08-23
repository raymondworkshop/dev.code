//GuessNum.cpp: Wenlong
//Description:  A guessing game where the player guesses the secret number

#include <iostream>
#include <cstdlib>
#include <ctime>
using namespace std;

int GenRanNum()
{
    srand(time(0)); // init rand
    
    return rand() % 100 + 1; // return the random number between 1 and 100
    
}


int main()
{
    int random_num = GenRanNum();
    cout << random_num <<endl;

    int input_var = 0;
    do{
        cout <<"Please input the guess( 1 to 100, -1 == quit):";
        cout <<endl;
        if(!(cin>>input_var))
        {
            cout << "The wrong input" <<endl;
            cin.clear();
            cin.ignore(1024,'\n');
        }else 
        {// write input
            
            //cout << "The wrong guess" <<endl;
            if ( input_var < random_num)
                cout << "that's too low" << endl;
            else if (input_var > random_num)
                cout << "that's too high" <<endl;
            else 
            {// right guess
                cout << "The right guess" <<endl;
                break;
            }
        }
        
    }while(input_var != -1);
    
    return 0;
}

