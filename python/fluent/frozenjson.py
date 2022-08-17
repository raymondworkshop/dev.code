"""
ex23-3 - 

properties replace a public data attribute with 
accessor methods (getter/setter) without changing the class interface
"""

# use the __getattr__ special method to convert data structures
# convert nested dicts and lists into nested FrozenJSON instances and lists of them
#
# use __new__ constructor method to transform a class into a flexible factory of objects

#
# note: a user-defined class implementing __getattr__ can implement
#    "virtual attributes" by computing values on the fly whenever somebody
#    tries to read a nonexistent attribute like obj.no_such_attr
#

from collections import abc
import keyword


class FrozenJSON:
    """navigate a JSON-like object using attribute notation"""

    # construct an instance using __new__
    def __new__(cls, arg):  # __new__ gets the class itself as the first argument
        if isinstance(arg, abc.Mapping):  # mapping
            return super().__new__(cls)  # object.__new__(FrozenJSON)
        elif isinstance(arg, abc.MutableMapping):  # list
            return [cls(item) for item in arg]
        else:  # str or int
            return arg

    def __init__(self, mapping):  # initializer
        # self.__data = dict(mapping)
        self.__data = {}
        for key, value in mapping.items():
            if keyword.iskeyword(key):
                key += "_"
            # if not key.isidentifier():
            #   key = "_" + key
            self.__data[key] = value

    # __getattr__ to return a different type of object
    # depending on the value of the attribute being accessed
    def __getattr__(self, name):
        if hasattr(self.__data, name):
            return getattr(self.__data, name)
        else:
            return FrozenJSON(self.__data[name])

    """
    @classmethod  # for alternative constructors, receiving the class itself instead of an instance
    def build(cls, obj):
        if isinstance(obj, abc.Mapping):  # if obj is a mapping
            return cls(obj)
        elif isinstance(obj, abc.MutableSequence):  # if it is a list
            return [cls.build(item) for item in obj]
        else:  # it is a str or an int
            return obj
    """


def main():
    student = FrozenJSON({"name": "Jim Bo", "birth": 1982})
    return


if __name__ == "__main__":
    main()
