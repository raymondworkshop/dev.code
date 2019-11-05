"""
item23: accept functions for simple interfaces instead of classes 
note:
"""
import collections

current = {'green': 2,
           'blue': 3}

increments = [
    ('red', 5),
    ('blue', 17),
    ('orange', 9),
]

# note: define a helper class that encapsulates the state we want to track
class CountMissing(object):
    def __init__(self):
        self.added = 0

    def __call__(self): # allow an object to be called just like a function
        self.added += 1
        return 0

    """
    def missing(self):
        self.added += 1
        return 0
    """

def increment_with_report(current, increments):
    added_count = 0

    def missing():
        #print('Key added')
        nonlocal added_count  #defining a closure for stateful hooks
        added_count += 1
        return 0

         
    # note: accept simple functions - missing - for interface
    result = collections.defaultdict(missing, current) 
    
    # note: a better solution 
    # - when we need a function to maintain state - added, consider defining a class that provides the __call__ method  
    counter = CountMissing()
    result = collections.defaultdict(counter, current) # be used like a function
    #print('Before: ', dict(result))
    for key, amount in increments:
        result[key] += amount
    #print('Afer: ', dict(result))

    return result, counter.added



if __name__ == "__main__":
    result, count = increment_with_report(current, increments)
    assert count == 2