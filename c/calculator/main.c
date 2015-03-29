//main.c
/*
  separe the functions into several source files
  because they would come from a separately-compiled lib in a realistic program.

  The source of the program may be kept in several files, and previously compiled routines
  may be loaded from libraries.
  
 */
#include <stdio.h>
#include <stdlib.h>  /* for atof() */
#include "calc.h"

#define MAXOP 100  /* max size of operand of operator */
//#define NUMBER '0' /* signal that a number was found */

/* function declarations for main */
//int getop(char []);

/* 1. it is better to put the pushing and poping a stack in a separate function than to repeat the code
 throuhout the whole program.
   2. main doesn't need to know about the variables that control the stack; it only does push and pop operations.
 So, storing the stack and its associated information in external variables accessible to the push and pop functions
 but not to main
*/
//void push(double);
//double pop(void);

/* reverse Polish calculator */
main()
{
  int type;
  double op2;
  char s[MAXOP];

  while( (type = getop(s)) != EOF)
  {
    switch(type){
    case NUMBER:
      push(atof(s));
      break;

    case '+':
      push(pop() + pop());
      break;

    case '*':
      push(pop() + pop());
      break;

    case '-':
      op2 = pop();  /* the temp variable op2 is used to store the poping the first value,
                       guaranteeing the right order for '-' and '/' */
      push(pop() - op2);
      break;
      
    case '/':
      op2 = pop();
      if(op2 != 0.0)
        push(pop() / op2);
      else
        printf("error: zero divisor\n");
      break;

    case '\n':
      printf("\t%.8g\n", pop());
      break;

    default:
      printf("error: unknown command %s\n", s);
      break;
    }
    
  }
  
  return 0;
    
}

