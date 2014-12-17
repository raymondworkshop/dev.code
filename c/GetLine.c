//getline.c
//get line into s, return length
#include <stdio.h>

int GetLine(char s[], int lim)  /* lim is the input line length*/
{
  int c, i;

  i = 0;
  while(--lim > 0 && (c=getchar()) != EOF && c != '\n')
    s[i++] = c;

  if(c == '\n')
    s[i++] = c;

  //'\0' marks the end o the string of characters
  s[i] = '\0';  
  
  return i;
  
}

