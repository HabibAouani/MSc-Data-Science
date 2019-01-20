# Ask the user for a number. Depending on whether
# the number is even or odd, print out an appropriate message
# to the user.

name = int(input("Please select a number :"))

if (name % 2 == 0) :
    print("This is an even number")
else :
    print("Looks like an odd one")

number1 = int(input("Please select a number to check :"))
number2 = int(input("Please select a number to divide it by :"))

if ((number1 / number2)%2 == 0) :
    print("divides evenly")
else :
    print("nope")