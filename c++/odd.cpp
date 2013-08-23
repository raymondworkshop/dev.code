// print out all odd num
#include <iostream>
using namespace std;

int main()
{
  for(unsigned int i = 1; i <= 100; i++)
    if (i & 0x00000001)
        cout << i <<",";
}


