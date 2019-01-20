#Take two lists and write a program that returns a list that
# contains only the elements that are common between
# the lists (without duplicates).
# Make sure your program works on two lists of different sizes.

import random

#Long option
a = random.sample(range(1, 100), 10)
b = random.sample(range(1, 100), 10)

c = []

for item in a:
    if item in b:
        if item not in c:
            c.append(item)

print (c)

#Or alternatively
commonList = set();

[commonList.add(x) for x in a for y in b if x == y]

print(list(commonList))