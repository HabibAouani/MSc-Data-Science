# Take a list, say for example this one:
# and write a program that prints out all the elements
# of the list that are less than 5.

a = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
new_list = []

number = int(input("Highest number : "))

for i in a :
    if i < number :
        new_list.append(i)

print(new_list)