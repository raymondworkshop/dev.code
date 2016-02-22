package exercise;

public class StackandQueue {
	class Node {
		Object data;
		Node next;
		
		Node(Object d) {
			this.data = d;
			this.next = null;
		}
	}
	
	//Last-in-first-out
   class Stack{
	   Node top;
	   
	   void push(Object item){
		   Node n = new Node(item);
		   n.next = top; // 
		   top = n;
	   }
	   
	   Object pop(){
		   if(top != null){
			 Object item = top.data;
			 top = top.next;
			 
			 return item;
		   }
		   
		   return null;
	   }
   }
   
   // Queue - first in first out
   class Queue {
	   Node first, last;
	   
	   void enqueue(Object item){
		   if(first == null){
			   last = new Node(item);
			   first = last;
		   }else{
			   last.next = new Node(item);
			   last = last.next;
		   }
	   }
	   
	   Object dequeue(){
		   if(first != null){
			   Object item = first.data;
			   first = first.next;
			   
			   return item;
		   }
		   
		   return null;
	   }
   }
   
   // test
   public static void main(String[] args){
	   
   }
   
}
