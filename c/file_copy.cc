#include <stdio.h>

main()
{
  //should declare c to be a type big enough to hold any value that getchar returns
  //so, int
  int c;
  //getchar reads the next input character from a text stream and returns that
  while ( (c = getchar()) != EOF )
  {
    putchar(c);
  }
  
}


