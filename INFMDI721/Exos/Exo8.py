import sys

user1 = str(input("What is your name player 1? "))
user2 = str(input("What is your name player 2? "))

user1_answer = input("%s Rock, Paper or Scisors" % user1)
user2_answer = input("%s Rock, Paper or Scisors" % user2)

def compare (u1, u2) :
    if u1 == u2 :
        return "It's a tie"
    elif u1 == "Rock" :
        if u2 == "Paper" :
            return "Paper wins"
        else : return "Rock wins"
    elif u1 == "Paper" :
        if u2 == "Rock" :
            return "Paper wins"
        else : return "Scisors wins"
    elif u1 == "Scisors" :
        if u2 == "Rock" :
            return "Rock wins"
        else : return "Scisors wins"
    else : return "Invalid output"
    sys.exit()

print(compare(user1_answer, user2_answer))