package basic;

public class QuickUnion{
    //static means that it only one instance of a static field exists,
    // all shared by all instances
    private static int[] id; 
    private static int[] sz; // count number of objects in the tree rooted at i
    
    public QuickUnion(int N){
        id = new int[N];

        for (int i=0; i<N; i++)
            id[i] = i;
        
        sz = new int[N];
        for(int i =0; i<N; i++)
            sz[i] = 0;
    }
    
    private static int root(int i){
        while(i != id[i])
            i = id[i];
        return i;
    }
    
    public static boolean connected(int p, int q){
        return root(p) == root(q);   
    }
    
    //link root of smaller tree to root of larger tree
    // make the tree more flat
    public static void union(int p, int q){
        int i = root(p);
        int j = root(q);
        if (sz[i] <= sz[j]) {
            id[i] = j; //add j to root of i
            sz[j] += sz[i];
        } else{
            id[j] = i;
            sz[i] += sz[j];
        }
        
    }
    
    public static void display(){
        for (int i=0; i<5; i++)
            System.out.print(id[i] + " ");
        System.out.println();
    }
    //test
    public static void main(String[] args){
        QuickUnion qu = new QuickUnion(5);
        display();
        union(0,3);
        display();
        union(4,0);
        display();
        union(2,0);
        display();
    }
}