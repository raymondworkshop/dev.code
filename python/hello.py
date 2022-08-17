import sys


# Define a main() function that prints a little greeting.
def hello():
    # Get the name from the command line, using 'World' as a fallback.
    if len(sys.argv) >= 2:
        name = sys.argv[1]
    else:
        name = "World"
    import pdb

    pdb.set_trace()

    print("Howdy", name)
    print("yay!")


def test():
    x = int(input("please enter an inter:"))
    if x < 0:
        x = 0
        print("Negative changed to zero")
    elif x == 0:
        print("Zero")
    elif x == 1:
        print("Single")
    else:
        print("More")


def test1():
    MAX_PRIME = 100
    sieve = [True] * MAX_PRIME
    for i in range(2, MAX_PRIME):
        # for j in range()
        # import pdb
        # pdb.set_trace()  ## DEBUG ##
        if sieve[i]:
            print(i)
            for j in range(i * i, MAX_PRIME, i):
                sieve[j] = False


# This is the standard boilerplate that calls the main() function.
if __name__ == "__main__":
    hello()
    #test()
    #test1()
