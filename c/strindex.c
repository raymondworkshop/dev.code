//strindex.c
//return index of t in s, -1 if none
int strindex(char s[], char t[])
{
  int i, j , k;

  for(i=0; s[i] != '\0'; i++)
  {
    for(j=i,k=0; t[k] !='\0' && s[j]==t[k] ; k++,j++)
      ;
    if(k > 0 && t[k] == '\0')
      return i;
  }

  //because c arrays begin at position zero, indexes will be zero or positive,
  // and so a negative value like -1 is convenient or signaling failure
  return -1;
    
}

