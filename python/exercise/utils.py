"""
some useful skills in python  
"""
#note1: the core of the program should use the str type 
#  unicode sandwich - "bytes on the outside, unicode on the inside, encode/decode at the edgesß"
def to_str(bytes_or_str):
    """
    take bytes or str, and return str
    """
    if isinstance(bytes_or_str, bytes):
        value = bytes_or_str.decode('utf-8')
    else:
        value = bytes_or_str
    return value

def to_bytes(bytes_or_str):
    # return bytes
    if isinstance(bytes_or_str, str):
        value = bytes_or_str.encode('utf-8') #str.encode()
    else:
        value = bytes_or_str
    return value

#notes: using F-strings to replace c-style format string
def to_print():
    d = {'id':123,
        'name': 'xiaoming'}
    f_string = f'user[{d["id"]}]: {d["name"]}'
    #f_string = f'_str'
    print(f_string)

def test_str(_input): # bytes
    _str = to_str(_input)
    _result = _str + " " + "lish"
    # out -> bytes
    _bytes = to_bytes(_result)
    return _bytes
    

if __name__ == "__main__":
    _input = b'foo'
    _output = test_str(_input)
    print(_output)

    #assert 'foo' == to_str(b'foo'), 'false'
    #print(to_str(repr(to_str(b'foo'))))
    to_print()