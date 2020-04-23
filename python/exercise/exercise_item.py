"""
Some effective python skills
"""

__all__ = ['item1','item2', 'item3', 'item4', 'item5', 'item6']

def item1():
    """list comprehensions"""
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
    print(repr(len_name))

def item2():
    """generator expressions avoid memory issues by produing outputs one at a time as an iterator
     could operate on a large stream of input 
    """
    a = [100, 57, 15, 1, 12, 75, 5, 86, 89, 11]
    it = ((x, x**0.5) for x in a)  # ()
    print(repr(it))
    print(repr(next(it)))
    print(repr(next(it)))

    #return

def item3():
    """prefer enumerate over range and indexing into a sequence"""
    flavor_list = ['vanilla', 'chocolate', 'pecan', 'strawberry']
    for i, flavor in enumerate(flavor_list, 1): # begin counting from 1
        #print('%d: %s' % (i, flavor))
        print(repr(i, flavor))

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

    #print('longest_name: %s, max_letters: %s' % (longest_name, max_letters))
    print(repr(longest_name, max_letters))

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
    """notes: use built-in modules for alg and data structrue"""

    """
    deque - double-ended queue
    """
    print("use deque in FIFO")
    from collections import deque
    # ideal for FIFO queues
    fifo = deque()
    #
    fifo.append(1) # producer
    fifo.append(2)
    fifo.append(2)
    x = fifo.popleft() # consumer; return and remove the leftmost item
    #print("x: ", x)
    print(repr(x))
    #print("fifo: ", fifo)
    print(repr(fifo))


    """
    use OrderedDict keep track of the inserted order
    """
    print("use OrderedDict keep track of the inserted order")
    from collections import OrderedDict
    #
    a = OrderedDict()
    a['foo'] = 1
    a['bar'] = 2
    b= OrderedDict()
    b['foo'] = 'red'
    b['bar'] = 'blue'
    for value1, value2 in zip(a.values(), b.values()):
        print(value1, value2)


    """
    use defaultdict to store a default value auto
    """
    print('use defaultdict to store a default value auto')
    from collections import defaultdict
    stats = defaultdict(int) # auto storing a default value when key doesn't exist
    #if 'counter' not in stats:
    #    stats['counter'] = 0
    stats['counter'] += 1 


    """
    heapq - heap queue, maintain a priority queue, and 
    """
    import heapq  # ???
    _li = [5,7,9,1,3]
    li = [8,2]
    heapq.heappush(li,5)
    heapq.heappush(li,3)
    heapq.heappush(li,7)
    heapq.heappush(li,4)
    print("heapq li: ", li)  # items can be rearraged based oh highest priority
    print("the 1st one: ", li[0])
    #

def item7():
    # note: enumerate provides concise looping to get the index  
    flavor_list = ['vanilla', 'chocolate', 'pecan', 'strawberry']
    for i, flavor in enumerate(flavor_list):
        print(f'{i+1}: {flavor}')

if __name__ == "__main__":
    #item1()
    #item2()
    #item3()
    #item4()
    #item5()
    item7()
    # functions
    #item6()

