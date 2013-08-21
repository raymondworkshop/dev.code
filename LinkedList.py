#LinkedList.py: wenlong
#Description: linked list in python
import sys

class Node:
    def __init__(self, cargo=None, next=None):
        self.cargo = cargo
        self.next = next

    def __str__(self):
        return str(self.cargo)

    
    def PrintBackward(self):
        #None represents the empty list, 
        #which is not legal to invoke a method on None
        #so, this function doesn't include in Node Class
        if self.next != None:  
            tail = self.next
            #import pdb; pdb.set_trace()
            tail.PrintBackward() 
            print self.cargo, # cargo is 1,2,3, which is in stack


#If the list contains no loops,
#then the function PrintList and PrintBackward will terminate     
def PrintList(node):
    if node == None: return
    
    print "[",
    while node:
        print node, #the comma in the print statement suppresses the newline
        node = node.next
        if node != None:
            print ",",
    print "]"
    #print #this print the newline

#remove the 2nd node
def RemoveSecond(list):
    if list == None: return
    if list.next == None: return
    first = list
    second = list.next
    first.next = second.next
    second.next = None
    return second

class LinkedList:
    def __init__(self):
        self.length = 0
        self.head = None

    def PrintBackwardNicely(self):
        print "["
        if self.head != None:
            self.head.PrintBackward()
        print "]"    

    def AddFirst(self, cargo):
        
def main():
    node1 = Node(1)
    node2 = Node(2)
    node3 = Node(3)

    node1.next = node2
    node2.next = node3
    PrintList(node1)
    
    PrintBackward(node1)

    RemoveSecond(node1)
    PrintList(node1)

    node4 = Node()
    PrintBackward(node4)
    

if __name__ == "__main__":
    main()
