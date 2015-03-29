//getch.c

#include <stdio.h>

/* 4. ungetch puts the pushed-back characters into a shared buffer - a character array.
   getch reads from the buffer if there is anything there, and calls getchar if the buffer is empty.
   an index variable that records the position of the current character in the buffer.

   since the buffer and the index are shared by getch and ungetch and must retain their values between calls,
   they must be external to both routines.
 */

#define BUFSIZE 100

/*
  static variable declaration, applied to an external variable or function, limits the scope of that object
  to the rest of the source file being compiled.
  - the private use of the function in the source file, and are not meant to be accessed by anything else.

  If a function is declared static, its name is invisible outside of the file in which it is declared.
 */

/* The static shared buffer and the index */
static char buf[BUFSIZE];  /* buffer for ungetch */
static int bufp = 0;       /* next free position in buf */

int getch(void) /* get a (possibly pushed back) character */
{
  return (bufp > 0) ? buf[--bufp] : getchar();
}

void ungetch(int c) /* push character back on input */
{
  if (bufp >= BUFSIZE)
    printf("ungetch: too many characters \n");
  else
    buf[bufp++] = c;
}
