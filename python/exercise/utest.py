"""
using pytest to do the testing
@author: raymond 
"""
import time
#import pytest
import unittest

from sentence import Sentence
from averager import averager

class SentenceTest(unittest.TestCase):
    def setUp(self):
        self.test = ['"The time has come," the Walrun said,',
                     'Hello, world'
        ]

    def tearDown(self):
        time.sleep(1)
        
    def test_sentence(self):
        s = Sentence(self.test[0])
        lst = ['The', 'time', 'has', 'come', 'the', 'Walrun', 'said']
        self.assertSequenceEqual(list(s), lst) 
        self.assertSequenceEqual(list(Sentence(self.test[1])), lst) 
        

class AveragerTest(unittest.TestCase):
    def SetUp(self):
        coro_avg = averager()
        
    
    def tearDown(self):
        return

    def test_averager(self):
        next(coro_avg)


if __name__ == '__main__':
    unittest.main()