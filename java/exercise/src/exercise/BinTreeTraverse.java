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
class Node {
	public int data;
	public Node left; //left child
	public Node right;//right
	//private Node parent;
	
	/*
	public Node(int data, Node parent, Node left, Node right){
		this.data = data;
		this.left = null;
		this.right = null;
		//this.parent = parent;
	}*/
	
	Node(int data){
		this.data = data;
		this.left = null;
		this.right = null;
		//this.parent = parent;
	}
	
}

public class BinTreeTraverse {
	
	public Node root;

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
		Node newnode = new Node(data);
		
		if(this.root== null){ // root
			root = new Node(data);
			
		}else{ //if not
            Node current = root;
            Node parent;
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
	private void printTree(Node node) {
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
	public void layerOrder(Node localroot){
		if(localroot == null){
			return;
		}
		
		/*
		ArrayList<Node> q = new ArrayList<Node>();
		q.add(root);
		*/
		
		//use the queue here to print
		Queue<Node> queue = new LinkedList<Node>();
		queue.add(localroot);
		
		
		while(!queue.isEmpty()){
			Node node = queue.poll();
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
