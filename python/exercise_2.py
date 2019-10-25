"""
 functions
"""

def function1():
    def divide(a, b):
        try:
            return a / b
        except ZeroDivisionError as e: 
            # return None  # function don't return an error prone
            raise ValueError('Invalid inputs') from e

    x, y = 5, 0
    try:
        result = divide(x, y)
    except ValueError:
        print('Invalid inputs')
    else:
        print('Result: %.1f' % result)

    return

def function2():
    return

def function3(): 
    """
    use generators as the alternative of returning lists of accumulated results
    """
    text = "Four score and seven years ago..."
    """
    result = [] #heavy
    if text:
        result.append(0)
    for index, letter in enumerate(text):
        if letter == ' ':
            result.append(index + 1) # create the list and return it
    return result
    """
    def index_words(text): #index_words function
        if text:
            yield 0  # generator does not actually run but instead immediately return an iterator 
                     # the iterator returned by the generator produces the set of values 
        for index, letter in enumerate(text):
            if letter == ' ':
                yield index + 1

    result = list(index_words(text))
    return result

def function4():
    def log(message, *values): #optional when we know the num of inputs in the arg list
        if not values:
            print(message)
        else:
            values_str = ', '.join(str(x) for x in values)
            print('%s: %s' % (message, values_str))
    
    log('My numbers are', 1, 2)
    log('Hi there')

    #return


if __name__ == "__main__":
    #function1()
    #function2() #todo-item15
    
    #function3()
    function4()