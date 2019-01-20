# Write a program that takes a list of numbers (for example, a = [5, 10, 15, 20, 25])
# and makes a new list of only the first and last elements of the given list.

def list_first_last(a) :
    new_list = []
    new_list.append(a[0])
    new_list.append(a[-1])
    return new_list

print(list_first_last([5,10,15,15]))