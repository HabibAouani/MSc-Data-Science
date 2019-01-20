# Create a program that asks the user for a number and then prints
# out a list of all the divisors of that number.

number = int(input("Select a number: "))
divisors = []
i = 1

while (i <= number) :
    if (number%i == 0) :
        divisors.append(i)
    i += 1

print(divisors)