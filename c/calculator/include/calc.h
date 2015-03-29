//calc.h
/*
  1. The definitions and declarations shared among the files.
  We wanna to centralized as much as possible so that there is only one copy to get right
  and keep right as the program evolves.

  we will place this common material in this header file.
  -- the declarations are organized so there is only one copy.

  2. there is a tradeoff between the desire that each file have access only to the information
  it needs for its job and the practical reality that it is harder to maintain more header files.

  it is probably best to have one header file that contains everything that is to be shared between any two parts of the program.
 */

#define NUMBER '0' /* shared between the two parts of the program */
void push(double);
double pop(void);
int getop(char []);
int getch(void);
void ungetch(int);

