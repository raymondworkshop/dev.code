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
    return


if __name__ == "__main__":
    #item1()
    #item2()
    item3()
    item4()