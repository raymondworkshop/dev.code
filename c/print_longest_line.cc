#include <stdio.h>

#define MAXLINE 1000  //maximum input line size

//3) extern variable: 
// relying too heavily on extern variables is fraught with peril
//since it leads to programs whose data connections are not at all obvious - variables can be changed in unexpected and even inadvertent ways

/*2) The purpose of supplying the size of an array, max_line here, in a declaration is to set aside storage */
int GetLine(char line[], int max_line);
void Copy(char to[], char from[]);

/*print longest input line */
main()
{
  int current_length;  //current line length
  int max_length;      //maximum length seen so far

  char line[MAXLINE];    //current input line
  char longest[MAXLINE];  //longest line saved here
  
  max_length = 0;
  
  while( (current_length = GetLine(line, MAXLINE)) > 0)
    if(current_length > max_length)
    {
      max_length = current_length;
      
      Copy(longest, line);
    }

  if (max_length > 0)
      printf("%s", longest);
    
    return 0;

}

/*GetLine: read line into s, return length*/
//1) In c, all function arguments are passed by value, which means
// the called function cannot directly alter a variable in the calling function;
//it can only alter its private, temporary copy;
//This is an asset, because parameters can be treated as conveniently initialized local variables in the called routine
int GetLine(char s[], int lim)  
{
    int c, i;

    for(i = 0; i<lim-1 && (c = getchar()) != EOF && c != '\n'; ++i)
      s[i] = c;

    if( c == '\n')
    {
      s[i] = c;
      ++i;
    }

    //'0' represents the null character, whose value is zero;
    // which marks the end of the string
    s[i] = '\0'; 
    
    return i;
    
  }

/* Copy: copy 'from' to 'to'; assume 'to' is big enough*/
void Copy(char to[], char from[])
{
    int i;
    
    i = 0;
    while((to[i] = from[i]) != '\0')
      ++i;
    
  }

