"""
Iterator pattern 
- generators are also called iterators 
- Generators produce data for iteration 

@wenlong
  - 03-07-2019 creation
"""

import  re
import reprlib

RE_WORD = re.compile('\w+')

class Sentence:
    def __init__(self, text):
        self.text = text
        #self.words = RE_WORD.findall(text)
    
    """
    def __getitem__(self, index): # make it iterable
        return self.words[index]

    def __len__(self):
        return len(self.words)
    """
    
    def __repr__(self):
        return 'Sentence(%s)' % reprlib.repr(self.text)
    
    """
    # use a generator function
    # __iter__ is a generator function to build a generator object which implements iterator interface 
    def __iter__(self): # call next() fetch the next item produced by field
        for word in self.words:
            yield word  #yield current word that is received by the caller of next()
        return
    """

    # a bette version  - a lazy implementation -> need to init all words firstly
    def __iter__(self):
        for match in RE_WORD.finditer(self.text): #finditer build an iterator over the matches of RE_WORD on self.text
            yield match.group() # extract the actual matched text


def firstn(n):
    num = 0

    while num < n:
        #nums.append(num)
        # a generator that yields items instead of returning a list 
        #
        # When the generator function called, it returns an object (iterator) but does not start execution immediately.
        # once the function yield statement is executed, the function is paused and transfers the control to the caller 
        # local variables and their states are remembered between successive calls
        #
        yield num  # return the generator object 
        num += 1

    #return nums

def main():
    txt = '"The time has come," the Walrun said,'

    s = Sentence(txt)
    print(list(s))

    first_n = firstn(10)
    # sum(iterable) -> the iterable calls the generator object created from the function firstn(n)
    sum_of_first_n = sum(first_n) # 
    print(sum_of_first_n)

    
    return 0

if __name__ == "__main__":
    main()
