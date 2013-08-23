#! /usr/bin/ipython
# -*- coding: utf-8 -*- 
#LinkedList.py: wenlong
#Description: linked list in python

class Node:
    def __init__(self, cargo=None, next=None):
        self.cargo = cargo
        self.next = next

    def __str__(self):
        return str(self.cargo)

    def PrintBackwardInline(self):
        if self.cargo == None:  return
        if self.next != None:
            tail = self.next
            #import pdb; pdb.set_trace()
            tail.PrintBackwardInline() #if tail is None, it isnot legal to have the attribute PrintBackwardInline
            #print self.cargo,  #print 2,1
        print self.cargo,  # cargo is 3; then 1,2 are in stack, then 2,1


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

    
def PrintBackward(list):
    #None represents the empty list, 
    #which is not legal to invoke a method on None
    #so, this function doesn't include in Node Class
    if list == None: return
    head = list
    tail = list.next
    PrintBackward(tail)
    print head,  ## head is 1,2,3, which is in stack, then 3,2,1

    
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
        self.length = 0 #length of the list
        self.head = None #reference to the first node

    def PrintBackwardNicely(self): #self is Node 
        if self.head != None:
            self.head.PrintBackwardInline()

    #put the cargo at the beginning of the list    
    def AddFirst(self, cargo):
        node = Node(cargo)
        node.next = self.head  #head references the old first, now this new next should point the old first
        self.head = node # head re-references the first
        self.length = self.length + 1

        
def main():
    node1 = Node(1)
    node2 = Node(2)
    node3 = Node(3)

    node1.next = node2
    node2.next = node3
    PrintList(node1)
    
    PrintBackward(node1)
    print
    print "-------"

    RemoveSecond(node1)
    PrintList(node1)

    list = LinkedList()
    list.AddFirst(0)
    list.AddFirst(1)
    list.PrintBackwardNicely()

    
if __name__ == "__main__":
    main()
