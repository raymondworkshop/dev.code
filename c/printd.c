//printd.c
/* print a number as a character string

   123 ->  321

   1. recursion - may provide no saving in storage, since somewhere a stack of the values being processed
   must be maintained.  Nor will it be faster.
   But recursive code is more compact, and often much easier to write and understand than the non-recursive equivalent.
   
 */
#include <stdio.h>

void printd(int);

int main()
{
  printd(-123);
  printf("\n");
  
}


/* printd: print n in decimal */
void printd(int n)
{
  if (n < 0)
  {
    putchar('-');
    n = -n;
  }

  if (n / 10)
    printd(n / 10);
    
  putchar(n % 10 + '0'); /* each invocation gets a fresh set of all the automatic variables */
    
}


