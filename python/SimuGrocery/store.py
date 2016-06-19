"""Assignment 1 - Grocery Store Models (Task 1)

This file should contain all of the classes necessary to model the entities
in a grocery store.
"""
# This module is used to read in the data from a json configuration file.
import json


class GroceryStore:
    """A grocery store.

    A grocery store should contain customers and checkout lines.

    TODO: make sure you update the documentation for this class to include
    a list of all public and private attributes, in the style found in
    the Class Design Recipe.
    """
    
    name = "" #unique customer identifier
    item_num = 0 #number of items each customer has
    
    def __init__(self, filename):
        """Initialize a GroceryStore from a configuration file <filename>.

        @type filename: str
            The name of the file containing the configuration for the
            grocery store.
        @rtype: None
        """
        with open(filename, 'r') as file:
            config = json.load(file)

        # <config> is now a dictionary with the keys 'cashier_count',
        # 'express_count', 'self_serve_count', and 'line_capacity'.
        
    def addCustomer(self, strname):
       """ each customer has a unique string identifier;
        and the number of items each customer has
       """
       self.name = strname
    
    def trackCheckoutines(self):  
        """ each checkout line holds a unique index
       hold the number of waiting customers
       """  

# You can run a basic test here using the default 'config.json'
# file we provided.
if __name__ == '__main__':
    store = GroceryStore('config.json')
    # Execute some methods here
