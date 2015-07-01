#include "wordcount.h"

/*treeprint: in-order print of tree p */
void treeprint(struct tnode *p)
{
  if(p != NULL)
  {
    treeprint(p->left);
    printf("%s %4d\n", p->word, p->count);
    treeprint(p->right);
  }
  
}

