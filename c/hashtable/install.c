// table lookup -
//
//  install (s, t) records the name s and the replacement text t in the table
//
//  lookup(s) searches for s in the table
//

#include "hashtable.h"
//
//the income name s is converted into a small non-negative integer,
// which is then used to index (hash) into an array of pointers.

// this array element points to the beginning of a linked list of blocks
// the block in the linked list

//struct nlist 
//{
//  char* name;          /* defined name */
//  char* defn;          /* replacement text */
//  struct nlist * next; /* next entry in chain */
//};

//#define HASHSIZE 101
//// the array of pointers/;
//static struct nlist *hashtab[HASHSIZE]; /* pointer table */

//the hashing process produces a starting index in the array hashtab

//
/* install: put (name, defn) in hashtab */
struct nlist *install(char* name, char* defn)
{
  struct nlist* np;
  unsigned hashval;

  if((np = lookup(name)) == NULL) /* not found */
  {
    np = (struct nlist *) malloc(sizeof(*np));
    if(np == NULL || (np->name = strdup(name)) == NULL)
       return NULL;

    hashval = hash(name);
    // put it in the linked list
    np->next = hashtab[hashval];
    hashtab[hashval] = np;
    
  } else { /* already there */
    free((void *) np->defn); /* free previous defn */
  }

  if((np->defn = strdup(defn)) == NULL)
    return NULL;
  
  return np;
}


