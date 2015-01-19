//searchpatern.c
//print each line o its input that contains a particular 'pattern' or string of characters
#include <stdio.h>
#define MAXLINE 1000 /* max input line here*/

//function declarations and definitins match, this make it possible for a compiler to detect many more errors than it could before

int GetLine(char line[], int max);             /* get line into s, return length */
int strindex(char source[], char searchfor[]); /* return index of t in s, -1 if none */

char pattern[] = "ould";  /* pattern to search for */

int main()
{
  char line[MAXLINE];
  int found = 0;
  
  while( GetLine(line, MAXLINE) > 0 )
  {
    if(strindex(line, pattern) >= 0 )
    {
      printf("%s", line);
      found++;
    }

  }
  //this returns a status -the num of matches found- from main,
  //this value is available for use by the environment that called the program
  return found;
  
}
                        
