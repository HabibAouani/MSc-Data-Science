#Ask the user for a number and determine whether the number is prime or not.

def isprime(user_input) :
    i = 1
    count = 0
    while i < int(user_input) :
        if (int(user_input) % i) == 0 :
            count = count + 1
        else : count = count
        i += 1
    if count == 1 :
        return "Nombre premier"
    else : return "Pas un nombre premier"

print(isprime(input("Votre nombre : ")))