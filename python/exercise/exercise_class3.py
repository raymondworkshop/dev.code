"""
class is to bundle data and functionality together  
"""
import unittest

class Dog:
    #tricks = [] # mistaken use of a class variable shared by all instances
    def __init__(self, name):
        self.name = name
        self.tricks = []  #

    def add_trick(self, trick):
        self.tricks.append(trick)

class TestDog(unittest.TestCase):
    def test_add_trick(self):
        d = Dog('Fibo')
        e = Dog('Buddy')
        d.add_trick('roll over')
        e.add_trick('play dead')

        print(d.tricks)
        print(e.tricks)
        print("hello, worlds")
        self.assertEqual(d.tricks, ['roll over', 'play deads'], "incorrect value")
        self.assertEqual(e.tricks, ['play dead'], "incorrect value")

if __name__ == '__main__':
#   import unittest
   unittest.main()

