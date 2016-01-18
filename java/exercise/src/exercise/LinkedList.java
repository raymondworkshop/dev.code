package exercise;


class Node {
	int data;
	Node next;
	
	Node(int d){
		this.data = d;
		this.next = null;
	}

	//insert
	void Insert(int d){
		Node node = new Node(d);
		
		//this return the reference to the current object
		Node n = this;
		while(n.next != null)
			n = n.next;
		
		n.next = node;
	}
	
	
	//  delete a node
	Node Delete(Node head, int d){
		Node n = head;
		
		if(n.data == d){
			return n.next; //change the head
		}
		
		while(n.next != null){
			if(n.next.data == d){
				n.next = n.next.next;
				return head;
			}
			n = n.next;
		}
		
	return head;
	}
	
	// remove duplicates 
	void RemoveDups(Node head){
		if(head == null)
			return;
		
		Node current = head;
		while(current != null){
			Node runner = current;
			
			while(runner.next != null){
				if(current.data == runner.next.data){
					runner.next = runner.next.next; //remove runner
				}else{
				
				runner = runner.next;
				}
			}
			
			current = current.next;
		}
	}
	
	//find the circle
	
	//display
	void Display(Node head){
	   while(head != null){
		   
		   System.out.println(head.data);
		   head = head.next;
	   }
	}
}
	// linked list
public class LinkedList {
	 //Node head = null;
	
	//test
	public static void main(String args[]){
		Node head=new Node(2);
		
		head.Insert(3);
		head.Insert(5);
		head.Insert(3);
		head.Insert(10);
		head.Display(head);
		
		//
		//Node myhead = head.Delete(head, 2);
		//myhead.Display(myhead);
		
		//Node node = new Node(3);
		head.RemoveDups(head);
		head.Display(head);
		
	}
	
}
