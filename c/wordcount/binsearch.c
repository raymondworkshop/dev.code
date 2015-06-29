#include  "wordcount.h"

//find word in tab[0]...tab[n-1]
// the list of keywords must be sorted in increasing order
struct key *binsearch(char* word, struct key *tab, int n)
{
  int cond;
  //int low, high, mid;

  //low = 0;
  //high = n - 1;
  struct key *low = &tab[0];
  struct key *high = &tab[n];
  struct key *mid;
  
  while(low < high)
  {
    //mid = (low + high) / 2;
    // the addition of two pointers is illegal, substraciton is legal.
    mid = low + (high - low) / 2;
    if((cond = strcmp(word, mid->word)) < 0) //word is less than the mid
      high = mid;
    else if (cond > 0)
      low = mid + 1;
    else
      return mid;
  }

  return NULL;
}

