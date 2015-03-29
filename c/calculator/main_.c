//main.c
#include <stdio.h>
#include <stdlib.h>  /* for atof() */

#define MAXOP 100  /* max size of operand of operator */
#define NUMBER '0' /* signal that a number was found */

/* function declarations for main */
int getop(char []);

/* 1) it is better to put the pushing and poping a stack in a separate function than to repeat the code
 throuhout the whole program.
   2) main doesn't need to know about the variables that control the stack; it only does push and pop operations.
 So, storing the stack and its associated information in external variables accessible to the push and pop functions but not to main */
void push(double);
double pop(void);

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
      printf("error: unknown command %n", s);
      break;
    }
    
  }
  
  return 0;
    
}

/* a variable is external if it is defined outside of any function;
   the stack and stack index that must be shared by push and pop are defined outside of the functions
 */
#define MAXVAL 100  /* max depth of val stack */
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

#include <ctype.h>
/* 3. For the case,  a program cannot determine that it has read enough input until it has read too much;
      one instance is  collecting the characters that make up a numer: until the first nondigit is seen, the number
    is not complete.
      a pair of cooperating funcoitns - getch() and ungetch()
*/
int getch(void);   
void ungetch(int); /* ungetch remembers the characters put back on the input,
                      so that subsequent calls to getch will return them before reading new input */

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



/* 4. ungetch puts the pushed-back characters into a shared buffer - a character array.
   getch reads from the buffer if there is anything there, and calls getchar if the buffer is empty.
   an index variable that records the position of the current character in the buffer.

   since the buffer and the index are shared by getch and ungetch and must retain their values between calls,
   they must be external to both routines.
*/

#define BUFSIZE 100

/* The shared buffer and the index */
char buf[BUFSIZE];  /* buffer for ungetch */
int bufp = 0;       /* next free position in buf */

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

