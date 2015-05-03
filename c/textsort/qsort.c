//quick sort
//

/* sort v[left]...v[right] into increasing order */
void qsort(char *v[], int left, int right)
{
  int i, last;
  void swap(char* v[], int i, int j);
  

  if(left >= right) /* do nothing if array contains */
    return;         /* fewer than two elements */

  swap(v, left, (left + right)/2);
  last = left;

  for(i = left+1; i<=right; i++)
  {
    if(strcmp(v[i], v[left]) < 0)
      swap(v, ++last, i);     
  }
  swap(v, left, last);  /* find the position of the left points to */
  
  qsort(v, left, last - 1);
  qsort(v, last+1, right);
  
}


/* interchange v[i] and v[j] */
void swap(char* v[], int i, int j)
{
  char* temp;

  temp = v[i];
  v[i] = v[j];
  v[j] = temp;
  
}
