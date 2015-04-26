//a rudimentary storage allocator
//
// 1. a large character array is used to store; The array is private to alloc and afree
//    Since they deal in pointers, not array indices, no other routine need know the name of the array,
//    which can be declared static in the source file containing alloc and afree, and thus be invisible outside it.
//    

#define ALLOCSIZE 10000 /* size of available space */

//Since they deal in pointers, not array indices, no other routine need know the name of the array
static char allocbuf[ALLOCSIZE]; /* storage for alloc */
static char *allocp = allocbuf;  /* the pointer allocp points to the next free element */

/* return pointer to n-consecutive characters */
char *alloc(int n)
{
  // if there is enough room left in allocbuf
  if(allocbuf + ALLOCSIZE - allocp >= n)
  {
    allocp += n;
    
    return allocp - n;  /* rerun the current value of allocp */
    
  } else

    // C guarantees that zero is never a valid address for data,
    // so a return value of zero can be used to signal an abnormal event, in this case, no space.
    return 0;
}

// free storage pointed to by p 
void afree(char *p)
{
  // if the two pointers point to members of the same array, then the relations work properly;
  // p<q is ture if p points to an earlier member of the array than q does.
  if( p >= allocbuf && p < allocbuf + ALLOCSIZE)
    allocp = p;
}

