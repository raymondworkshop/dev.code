#
# ch9 - decorators and closures
# note: use for separating concerns and avoiding external unrelated logic "polluting"
#       the core logic of the function or method
#


def decorator(func):
    # manipulate func
    def inner():
        print("running inner()")

    return inner


# target = decorator(target)

# target() is decorated
@decorator
def target():
    print("running target()")
    return


# implement a simple decorator
# a clock decorator
import time
import functools


def clock(func):
    @functools.wraps(func)  # copy the relevant attributs from func to colcked
    def clocked(*args, **kwargs):
        t0 = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - t0
        name = func.__name__
        arg_lst = [repr(arg) for arg in args]
        arg_lst.extend(f"{k}={v!r}" for k, v in kwargs.items())
        arg_str = ", ".join(arg_lst)
        print(f"[{elapsed:0.8f}s] {name}({arg_str}) -> {result!r}")
        return result

    return clocked


@functools.cache  # save the result of previous invocations of an expensive function
@clock
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 2) + fibonacci(n - 1)


def main():
    print(fibonacci(6))
    return


if __name__ == "__main__":
    main()
