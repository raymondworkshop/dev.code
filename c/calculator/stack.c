//stack.c
#include <stdio.h>
#include "calc.h"
/* 1. if an external variable is to be referred to before it is defined,
   or if it is defined in a different source file from the one where it is being used,
   then an extern declaration is mandatory.

   There must be only one definition of an external variable among all the files
   that make up the source program; other files may contain extern declarations to access it.
*/

/* a variable is external if it is defined outside of any function;
   the stack and stack index that must be shared by push and pop are defined outside of the functions
*/

#define MAXVAL 100  /* max depth of val stack */

/* the shared stack index and stack */
int sp = 0;         /* next free stack position */
double val[MAXVAL]; /* value stack */

/* external variables for push and pop */
void push (double f)
{
  if (sp < MAXVAL)
      val[sp++] = f;
  else
    printf("error: stack full, can't push %g\n", f);
}

/* pop and return top variable from stack*/
double pop(void)
{
  if (sp > 0)
    return val[--sp];
  else
  {
    printf("error: stack empty\n");
    return 0.0;
  }
}
