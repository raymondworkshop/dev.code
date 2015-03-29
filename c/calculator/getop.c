#include <stdio.h>
#include <ctype.h>
#include "calc.h"

/* 3. For the case,  a program cannot determine that it has read enough input until it has read too much;
      one instance is  collecting the characters that make up a numer: until the first nondigit is seen, the number
    is not complete.
      a pair of cooperating funcoitns - getch() and ungetch()
*/
//int getch(void);   
//void ungetch(int); /* ungetch remembers the characters put back on the input,
//                      so that subsequent calls to getch will return them before reading new input */


/* fetches the next operator or numeric operand */
int getop(char s[])
{
  int i, c;

  /* skip blanks and tabs */
  while( (s[0] = c = getch()) == ' ' || c == '\t')
    ;
  
  s[1] = '\0'; // the same as s[1] = 0; a string terminat
  
  if(!isdigit(c) && c != '.')  /* not a number: not a digit or a decimal point */
    return c;

  //otherwise, collect a string of digits, and return NUMBER
  i = 0;
  if (isdigit(c))  /* collect integer part */
    while( isdigit( s[++i] = c = getch() ) )
      ;
  if (c == '.')    /* collect fraction part */
    while( isdigit( s[++i] = c = getch() ) )
      ;
  s[i] = '\0';

  if(c != EOF)
    ungetch(c);
  
  return NUMBER; /* the signal that a number has been collected */
  
}
