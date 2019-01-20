#Source : https://www.practicepython.org/

#Create a program that asks the user to enter their name and their age.
# Print out a message addressed to them that tells them the year
# that they will turn 100 years old.

name = str(input("What is your name? "))
age = int(input("How old are you? "))
year = str(int(2018-age+100))
print('Hi ' + name + ', you will be 100 by the year : ' + year)
