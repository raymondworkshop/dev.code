"""
ch3
example 3-9 - converts non-string keys to str - on insertion, update, and lookup
"""
import collections

# Automatic handling of missing keys
# #note: better to create a new mapping type by extending 
# collections.UserDict rather than dict
class StrKeyDict(collections.UserDict):
    def __missing__(self, key):
        if isinstance(key, str):
            raise KeyError(key)
        return self[str(key)]

    def __contains__(self, key):
        return str(key) in self.data   #data holds the actual items

    def __setitem__(self, key, item):
        self.data[str(key)] = item

def main():
    d = StrKeyDict([('2', 'two'), ('4', 'four')])
    print(d)
    return


if __name__ == "__main__":
    main()