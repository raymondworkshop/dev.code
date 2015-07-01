#include "wordcount.h"

#include <stdlib.h>

struct tnode *talloc(void);
char* strdup_t(char*);

//binary tree for the sort

/* addtree: add a node with w, at or below p */
struct tnode *addtree(struct tnode* p, char* w)
{
  int cond;

  if(p == NULL){    /* a new word has arrived */
    p = talloc();   /* make a new node */
    p->word = strdup(w);
    p->count = 1;
    p->left = p->right = NULL;
    
  }else if ((cond = strcmp(w, p->word)) == 0){  /* repeated word */
    p->count++;
    
  }else if (cond < 0){ /* less than into left subtree */
    p->left = addtree(p->left, w);
    
  } else{              /* greater than into right subtree */
    p->right = addtree(p->right, w);
  }
  
  return p; // return a pointer to a new node
}

/* talloc: make a tnode */
struct tnode *talloc(void)
{
  return (struct tnode *) malloc(sizeof(struct tnode));
}

/* strdup: make a duplicate */
char* strdup_t(char* s)
{
  char* p;

  p = (char *) malloc(strlen(s)+1); /* add '\0' */
  if (p != NULL)
    strcpy(p, s);

  return p;
}

