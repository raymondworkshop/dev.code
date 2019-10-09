"""
Effective python
"""

def item1():
    #list comprehensions
    a = [1,2,3,4,5,6,7,9]
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

if __name__ == "__main__":
    item1()