"""
ch11 - a pythonic Object
"""
# vector2d.py

import math
from array import array

class Vector2d:
    #list the instance attributes in the order 
    # they will be used for positional pattern matching 
    __match_args__ = ('x', 'y') # list the public attribute names for positional pattern matching  

    typecode = 'd' # the type of objects stored in object

    def __init__(self, x, y):
        self.x = float(x)
        self.y = float(y)

    def __repr__(self):
        class_name = type(self).__name__
        return '{}({!r}, {!r})'.format(class_name, *self)
        #return f"Vector({self.x!r}, {self.y!r})"

    def __str__(self):
        return str(tuple(self))

    def __bytes__(self):
        return (bytes([ord(self.typecode)]))  +  bytes(array(self.typecode,self))

    def __add__(self, other):
        x = self.x + other.x
        y = self.y + other.y
        return Vector2d(x, y)

    def __mul__(self, scalar):
        return Vector2d(self.x * scalar, self.y * scalar)

    def __abs__(self):
        return math.hypot(self.x, self.y)

    def __bool__(self):
        return bool(abs(self))

    def __iter__(self):  # make unpacking work
        return (i for i in (self.x, self.y))

    def __eq__(self, other):
        return tuple(self) == tuple(other)

    def __format__(self, fmt_spec=""):  # format
        components = (format(c, fmt_spec) for c in self)
        return "({}, {})".format(*components)

    def __hash__(self):  # hashable
        return hash(self.x) ^ hash(self.y)

    @classmethod
    def frombytes(cls, octets):
        typecode = chr(octets[0])
        memv = memoryview(octets[1:]).cast(typecode)
        return cls(*memv)

class ShortVector2d(Vector2d):
    typecode = 'f'


def test_vector():
    v1 = Vector2d(2, 4)
    v2 = Vector2d(2, 1)
    print(v1 + v2)

    v = Vector2d(3, 4)
    print(v * 3)

    print(abs(v))

    octets = bytes(v1)
    print(octets)


def test_keyword_pattern(v: Vector2d) -> None:
    match v:
        case Vector2d(x=0, y=0):
            print(f'{v!r} is null')
        case Vector2d(0,_):
            print(f'{v!r} is vertical')
        case Vector2d(_, 0):
            print(f'{v!r} is horizontal')
        case _:
            print(f'{v!r} is awesome')
    
def test_ShortVector2d(sv: ShortVector2d) -> None:
    print(sv)

if __name__ == "__main__":
    test_vector()
    #
    test_keyword_pattern(Vector2d(2, 0))
    #
    test_ShortVector2d(ShortVector2d(1/11, 1/27))
