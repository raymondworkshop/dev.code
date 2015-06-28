#include  "wordcount.h"

//find word in tab[0]...tab[n-1]
// the list of keywords must be sorted in increasing order
int binsearch(char* word, struct key tab[], int n)
{
  int cond;
  int low, high, mid;

  low = 0;
  high = n - 1;
  while(low <= high)
  {
    mid = (low + high) / 2;
    if((cond = strcmp(word, tab[mid].word)) < 0) //word is less than the mid
      high = mid - 1;
    else if (cond > 0)
      low = mid + 1;
    else
      return mid;
  }

  return -1;
}

