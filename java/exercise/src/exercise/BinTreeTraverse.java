package exercise;

/*
 * @author wenlong
 *
 * The running result:
 *  -----------------
 *  8 6 10 5 7 9 11 
 *   Done. 
 * */

import java.util.Queue;
//import java.util.ArrayList;
import java.util.LinkedList;

// define a Node class
class Node_ {
	public int data;
	public Node_ left; //left child
	public Node_ right;//right
	//private Node parent;
	
	/*
	public Node(int data, Node parent, Node left, Node right){
		this.data = data;
		this.left = null;
		this.right = null;
		//this.parent = parent;
	}*/
	
	Node_(int data){
		this.data = data;
		this.left = null;
		this.right = null;
		//this.parent = parent;
	}
	
}

public class BinTreeTraverse {
	
	public Node_ root;

	// create a null bi tree
	public BinTreeTraverse(){
		this.root = null;
	}
	
	
	// build the binary tree
	public void buildTree(int[] data){
		for(int i =0; i<data.length; i++){
			insert(data[i]);
		}
	}
	
	private void insert(int data){
		Node_ newnode = new Node_(data);
		
		if(this.root== null){ // root
			root = new Node_(data);
			
		}else{ //if not
            Node_ current = root;
            Node_ parent;
            while(true){
            	parent = current;
            
			    if(data <= current.data) { //based on teh BT definition
				    current = current.left;
				    if(current == null){
			    	   //parent.left = insert(node.left, data); // new one
				       parent.left = newnode;
				       return;
				    } 
				    
			    } else { //
			    	current = current.right;
			    	if(current == null){
				    	   //parent.left = insert(node.left, data); // new one
					       parent.right = newnode;
					       return;
					 }  
            }
	    } //while
            
		}
		
	}
	
	// print the tree
	private void printTree(Node_ node) {
		if (node == null) {
			return;
		}

		// left, node itself, right
		printTree(node.left);
		System.out.print(node.data + "  ");
		printTree(node.right);

	}
	
	// level order
	
	public void layerOrder(){
		//begin from the root
		this.layerOrder(this.root); //

	}
	
	// level order
	public void layerOrder(Node_ localroot){
		if(localroot == null){
			return;
		}
		
		/*
		ArrayList<Node> q = new ArrayList<Node>();
		q.add(root);
		*/
		
		//use the queue here to print
		Queue<Node_> queue = new LinkedList<Node_>();
		queue.add(localroot);
		
		
		while(!queue.isEmpty()){
			Node_ node = queue.poll();
			// visit the head
			System.out.print(node.data +  " ");
			
			if(node.left != null){ // keep left child in the list
				queue.add(node.left);
			}
			
			if(node.right != null) // keep right chil in the list
				queue.add(node.right);
		}
		
		System.out.println();
	}
	
	//test
	public static void main(String[] args){
		//init
		int[] data = {8,6,10,5,7,9,11};
		
		BinTreeTraverse bt = new BinTreeTraverse();
		
		//build the tree
		bt.buildTree(data);
		
		//bt.printTree(root);
		
		//print the level order
        bt.layerOrder();	
        
		System.out.println("Done.");
	}

}
