//readlines.c - read input lines
//
//#define MAXLEN 1000 /* max length of any input line */
//int _getline(char*, int);
//char* _alloc(int);
#include "textsort.h"

/* readlines: read input line */
int readlines(char* lineptr[], int maxlines)
{
  int len, nlines;
  char* p, line[MAXLEN];

  nlines = 0;
  while((len = getline_(line, MAXLEN)) > 0)
  {
    if(nlines >= maxlines || (p = alloc_(len)) == NULL)
    {
      return -1;
    }
    else
    {
      line[len-1] = '\0'; /* delete newline */
      
      strcpy(p, line);
      lineptr[nlines++] = p;
    }
  }

  return nlines;
  
}

/* write output lines */
void writelines(char* lineptr[], int nlines)
{
  while(nlines-- > 0)
    printf("%s\n", *lineptr++);
  
}
