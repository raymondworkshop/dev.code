//testsort.h
#ifndef TEXTSORT
#define TEXTSORT

#include <stdio.h>
#include <string.h>

//the input function can only cope with a finite number of input lines
#define MAXLINES 5000     /* max #lines to be sorted */

char* lineptr[MAXLINES];  /* pointers to text lines */

int readlines(char* lineptr[], int nlines);       /* read all the lines of input */

void qsort(char* lineptr[], int left, int right);  /* sort them */
void writelines(char* lineptr[], int nlines);  /* print them in order */

/* for the readlines */
#define MAXLEN 1000 /* max length of any input line */
int getline_(char*, int);
char* alloc_(int);


#endif
