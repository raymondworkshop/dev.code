"""
Some effective python skills
"""

def item1():
    #list comprehensions
    a = [1, 2, 3, 4, 5, 6, 7, 9]
    even_squares = [x**2 for x in a if x % 2 == 0]
    print(even_squares)

    #dict
    ranks = {'ghost':1,
             'habanero': 2,
             'cayenne':3}
    rank_dict = {rank: name for name, rank in ranks.items()}
    print(repr(rank_dict))

    len_name = {name: len(name) for name in ranks.keys()}
    print(len_name)

def item2():
    #generator expressions avoid memory issues by produing outputs one at a time as an iterator
    # could operate on a large stream of input 
    a = [100, 57, 15, 1, 12, 75, 5, 86, 89, 11]
    it = ((x, x**0.5) for x in a)  # ()
    print(it)
    print(next(it))
    print(next(it))

    #return

def item3():
    #prefer enumerate over range and indexing into a sequence
    flavor_list = ['vanilla', 'chocolate', 'pecan', 'strawberry']
    for i, flavor in enumerate(flavor_list, 1): # begin counting from 1
        print('%d: %s' % (i, flavor))

    #return

def item4():
    names = ['cecilia', 'lise', 'marie'] 
    letters = [len(n) for n in names]

    longest_name = None
    max_letters = 0
    for name, count in zip(names, letters): #zip wraps two or more iterators with a lazy generator
        if count > max_letters:
            longest_name = name
            max_letters = count

    print('longest_name: %s, max_letters: %s' % (longest_name, max_letters))

def item5():
    # generate random int
    #from random import seed
    #from random import randint
    #seed(1)
    import logging
    # unicode file
    f = open('random_data.txt', 'w', encoding='utf-8')
    f.write('success\nand\nnew\nlines')
    f.close()

    handle = open('random_data.txt', 'r') # may raise IOError
    try:
        data = handle.read()  # may raise UnicodeDecodeError
    except UnicodeDecodeError as e: # handle excepts
        raise UnicodeDecodeError from e
    else: # distinguish the success case from the try/except blocks, and perform additional actions
        logging.info(data+"-end")
    finally: # always run after try regardless of whether exceptions were raised
        handle.close() 

    #return

def item6():
    def divide(a, b):
        try:
            return a / b
        except ZeroDivisionError as e: 
            # return None  # an error prone
            raise ValueError('Invalid inputs') from e

    x, y = 5, 0
    try:
        result = divide(x, y)
    except ValueError:
        print('Invalid inputs')
    else:
        print('Result: %.1f' % result)

    return

if __name__ == "__main__":
    #item1()
    #item2()
    #item3()
    #item4()
    #item5()
    # functions
    item6()

