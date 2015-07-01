//count the occurrences of each C keyword
//
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
*/


#define MAXWORD 100

//int getword(char*, int);
//int binsearch(char*, struct key *, int);

//NKEYS is the number of keywords in keytab
//2. the advantage here using keytab[0] is that it does not need to be changed if the type key changes
// define NEKYS (sizeof keytab / sizeof(struct key))
#define NKEYS (sizeof keytab  / sizeof keytab[0])

int main()
{
  struct tnode *root; // pointer to array structure
  char word[MAXWORD];

  root = NULL;
  while(getword(word, MAXWORD) != EOF) // getword() fetches the next "word" from the input
  {
    if(isalpha(word[0])){
      /*
      if((p = binsearch(word, keytab, NKEYS)) != NULL) //each word is looked up in keytab with binsearch
      {
        p->count++;
      }
      */
      // a recursive
      // at each stage, the word is compared to the word already stored at the node, and is percolated down to
      // either the left or right subtree by a recursive call to address.
      // Eventually the word either matches something already in the tree , or a null pointer is encountered,
      //indicating that a node must be created and added to the tree
      root = addtree(root, word);
    }
  }

  treeprint(root);
  
  return 0;
}


