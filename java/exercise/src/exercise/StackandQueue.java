package exercise;

public class StackandQueue {
	class Node {
		int data;
		Node next;
		
		Node(int d) {
			this.data = d;
			this.next = null;
		}
	}
	//Last-in-first-out
   class Stack{
	   Node top;
	   
	   void push(int item){
		   Node n = new Node(item);
		   n.next = top; // 
		   top = n;
	   }
	   
	   
   }
   
   //
}
