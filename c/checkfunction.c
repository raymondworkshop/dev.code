//check_function.c
//this function mainly uses as a main() function to check the called functions
#include <stdio.h>

#define MAXLINE 100

main()
{
  //check atof() functions
  /*1) atof() should be declared here, because
     If atof were compiled separately, the mismatch would not be detected,
     atof() would return a double that main() would treat as an int (this is because
     if a name that has not been previously declared occurs in an expression and is followed by a left parenthesis,
     it is declared by context to be a funciton name,  the function is assumed to return an int)
   */
  double sum, atof(char[]);
  char line[MAXLINE];
  int getline(char line[], int max);
  
  sum = 0;
  while(getline(line, MAXLINE) > 0)
    printf("\t%g\n", sum += atof(line));

  return 0;
    
}

