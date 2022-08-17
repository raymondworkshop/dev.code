# -*- coding: utf-8 -*-

MAX_PRIME = 5


sieve = [True] * MAX_PRIME
for i in range(2, MAX_PRIME):
    if sieve[i]:
        print(i)
        for j in range(i*i, MAX_PRIME, i):
            sieve[j] = False


"""
    if sieve[i]:
        print(i)
        for j in range(i * i, MAX_PRIME, i):
            sieve[j]
"""
print(sieve)

print("Hello, World!")
