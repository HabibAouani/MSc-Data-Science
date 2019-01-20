#Ask the user for a string and print out whether
# this string is a palindrome or not.

wrd = input("Please enter a word to check and see if it's a palindrome:\n")
wrd = wrd.replace(" ","")
wrd = (wrd.lower())
rvs = (wrd.lower()[::-1])

if rvs == wrd:
    print("This is a palindrome!")
else:
    print("This is not a palindrome.")
