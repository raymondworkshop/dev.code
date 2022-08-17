"""
ch12
"""

from array import array
import reprlib
import math
import operator

# import pytest


class Vector:
    typecode = "d"

    def __init__(self, components):
        self._components = array(self.typecode, components)

    def __repr__(self):
        components = reprlib.repr(self._components)
        components = components[components.find("[") : -1]
        return f"Vector({components})"

    def __str__(self):
        return str(tuple(self))

    # to allow iteration, return an iterator
    def __iter__(self):
        return iter(self._components)

    def __bytes__(self):
        return bytes([ord(self.typecode)]) + bytes(self._components)

    # tuple(t) simply returns a reference to the same t, no copy
    def __eq__(self, other):
        return tuple(self) == tuple(other)

    def __abs__(self):
        return math.hypot(*self)

    def __bool__(self):
        return bool(abs(self))

    # dynamic protocols - special methods
    # duck typing - it's a sequence because it implements the
    # necessary sequence methods
    def __len__(self):
        return len(self._components)

    # A slice-Aware __getitem__
    def __getitem__(self, key):
        if isinstance(key, slice):
            cls = type(self)
            return cls(self._components[key])
        index = operator.index(key)
        return self._components[index]

    # to allow pattern matching on the dynamic attributes
    # supported by __getattr__
    __match_args__ = ("x", "y", "z", "t")

    # dynamic attribute access
    def __getattr__(self, name):
        cls = type(self)
        try:
            # get the position of name in __match_args__
            pos = cls.__match_args__.index(name)
        except ValueError:
            pos = -1

        if 0 <= pos < len(self._components):
            return self._components[pos]
        msg = f"{cls.__name__!r} object has no attribute {name!r}"

        raise AttributeError(msg)

    def __eq__(self, other):
        return tuple(self) == tuple(other)

    def __hash__(self):  # instance hashable
        return hash(self.x) ^ hash(self.y)

    def __format__(self, fmt_spec=""):  # format
        components = (format(c, fmt_spec) for c in self)
        return "({}, {})".format(*components)

    @classmethod
    def frombytes(cls, octets):
        typecode = chr(octets[0])
        memv = memoryview(octets[1:].cast(typecode))
        return cls(memv)


def test_Vector():
    v = Vector(range(7))
    print(v[1:4])

    return


if __name__ == "__main__":
    test_Vector()
