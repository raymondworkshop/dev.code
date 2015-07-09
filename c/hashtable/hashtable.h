#ifndef HASHTABLE_H
#define HASHTABLE_H

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "hashtable.h"
//
//the income name s is converted into a small non-negative integer,
// which is then used to index (hash) into an array of pointers.

// this array element points to the beginning of a linked list of blocks
// the block in the linked list
struct nlist 
{
  char* name;          /* defined name */
  char* defn;          /* replacement text */
  struct nlist * next; /* next entry in chain */
};

#define HASHSIZE 101
// the array of pointers/;
static struct nlist *hashtab[HASHSIZE]; /* pointer table */

unsigned hash(char* s);

struct nlist* lookup(char* name);
struct nlist* install(char* name, char* defn);

#endif
