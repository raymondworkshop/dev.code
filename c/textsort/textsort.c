//textsort.c - sort a set of text lines into alphabetic order
//
//1. the array of pointers are used  [ch 5.6]
//       * each line can be accessed by a pointer to its first character,
//   and the pointers can be stored in an array
//       * two lines can be compared by passing their pointers to strcmp;
//   when two out-of-order lines have to be exchanged, the pointers in the pointers array are exchanged,
//   not the text lines themselves.
//       * this eliminates the twin problems of complicated storage management and high overhead that go
//   with moving the lines themselves.
//
#include <stdio.h>
#include <string.h>

//the input function can only cope with a finite number of input lines
//#define MAXLINES 5000     /* max #lines to be sorted */

//char *lineptr[MAXLINES];  /* pointers to text lines */

//int readlines(char* lineptr[], int nlines);       /* read all the lines of input */

//void qsort(char* lineptr[], int left, int right);  /* sort them */
//int writelines(char* lineptr[], int nlines);  /* print them in order */
#include "textsort.h"

/* sort input lines */
int main()
{
  int nlines;  /* number of input lines read */

  if((nlines = readlines(lineptr, MAXLINES)) >= 0)
  {
    qsort(lineptr, 0, nlines-1);
    writelines(lineptr, nlines);

    return 0;
    
  } else 
  {
    printf("error: input too big to sort\n");

    return 1;
    
  }
  
}

