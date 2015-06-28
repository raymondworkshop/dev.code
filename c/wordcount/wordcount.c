//a program to count the occurrences of each C keyword
// present the arrays of structure
//

//#include <stdio.h>
//#include <ctype.h>
//#include <string.h>

#include "wordcount.h"

/*
// declare a structure type key - (arrays are parallel)
struct key {
  char* word;
  int count;
};
*/

//1. define an array keytab of structures
struct key keytab[] =
  {
    "auto", 0,
    "break",0,
    "case", 0,
    "char", 0,
    "const",0,
    "continue",0,
    "default",0,
    "unsigned",0,
    "void", 0,
    "while",0
  };

#define MAXWORD 100

//int getword(char*, int);
//int binsearch(char*, struct key *, int);

//NKEYS is the number of keywords in keytab
//2. the advantage here using keytab[0] is that it does not need to be changed if the type key changes
// define NEKYS (sizeof keytab / sizeof(struct key))
#define NKEYS (sizeof keytab  / sizeof keytab[0])

int main()
{
  int n;
  char word[MAXWORD];

  while(getword(word, MAXWORD) != EOF) // getword() fetches the next "word" from the input
  {
    if(isalpha(word[0])){
      if((n = binsearch(word, keytab, NKEYS)) >= 0) //each word is looked up in keytab with binsearch
      {
        keytab[n].count++;
      }
    }
  }
  
  for(n = 0; n < NKEYS; n++)
  {
    if(keytab[n].count > 0)
      printf("%4d %s\n", keytab[n].count, keytab[n].word);
  }

  return 0;
}


