#Take 2 lists and write a program that returns a list that contains only the elements
# that are common between the lists (without duplicates) using list comprehension.

import random

a = random.sample(range(1,100), 19)
b = random.sample(range(1,100), 30)
result = [i for i in a if i in b]
print(result)