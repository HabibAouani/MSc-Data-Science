# Written with <3 by Julien Romero
import hashlib
from sys import argv
import sys
import itertools
if (sys.version_info > (3, 0)):
    from urllib.request import urlopen
    from urllib.parse import urlencode
else:
    from urllib2 import urlopen
    from urllib import urlencode


class Crack:
    """Crack The general method used to crack the passwords"""

    def __init__(self, filename, name):
        """__init__
        Initialize the cracking session
        :param filename: The file with the encrypted passwords
        :param name: Your name
        :return: Nothing
        """
        self.name = name.lower()
        self.passwords = get_passwords(filename)

    def check_password(self, password):
        """check_password
        Checks if the password is correct
        !! This method should not be modified !!
        :param password: A string representing the password
        :return: Whether the password is correct or not
        """
        password = str(password)
        cond = False
        if (sys.version_info > (3, 0)):
            cond = hashlib.md5(bytes(password, "utf-8")).hexdigest() in \
                self.passwords
        else:
            cond = hashlib.md5(bytearray(password)).hexdigest() in \
                self.passwords
        if cond:
            args = {"name": self.name,
                    "password": password}
            args = urlencode(args, "utf-8")
            page = urlopen('http://137.194.211.71:5000/' +
                                          'submit?' + args)
            if b'True' in page.read():
                print("You found the password: " + password)
                return True
        return False
        
    def evaluate(self):
        """evaluate
        Retrieve the grade from the server,
        !! This method MUST not be modified !!
        """
        args = {"name": self.name }
        args = urlencode(args, "utf-8")
        page = urlopen('http://137.194.211.71:5000/' + 'evaluate?' + args)
        print("Grade :=>> " + page.read().decode('ascii').strip())

    def crack(self):
        """crack
        Cracks the passwords. YOUR CODE GOES BELOW.
        
        We suggest you use one function per question. Once a password is found,
        it is memorized by the server, thus you can comment the call to the
        corresponding function once you find all the corresponding passwords.
        """
        #self.bruteforce_digits()
        #self.bruteforce_letters()
        #self.dictionnary_passwords()
        #self.dictionnary_passwords_and_digits()
        #self.dictionnary_nouns_cat()
        #self.dictionnary_nouns_diceware()
        #self.dictionnary_words()
        #self.dictionnary_words_leet()
        #self.social_google()
        self.social_jdoe()
    
    def bruteforce_digits(self):
        num = ['0','1','2','3','4','5','6','7','8','9']
        
        for r in range(1,9) :
            for s in itertools.product(num, repeat=r):
                self.check_password(''.join(s))

    def bruteforce_letters(self):
        
        letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
        
        for r in range(1,6) :
            for s in itertools.product(letters, repeat=r):
                self.check_password(''.join(s))
            
    def dictionnary_passwords(self):
        
        with open("/Users/maelfabien/TelecomParisTech/INF344/psw.txt") as infile:
            for password in infile:
                password = password[:-2]
    #self.check_password(password)
                
                #print(password)
                if len(password) < 10 :
                    for word in map(''.join, itertools.product(*((c.upper(), c.lower()) for c in password))) :
                        self.check_password(word)
                else :
                    self.check_password(password)
                        
    
    def dictionnary_passwords_and_digits(self):

        with open("/Users/maelfabien/TelecomParisTech/INF344/psw.txt") as infile:
            for password in infile:
                num = ['0','1','2','3','4','5','6','7','8','9']
                password = password[:-2]
                for r in range(1,3) :
                    for s in itertools.product(num, repeat=r):
                        w = ''.join(str(password) + str(''.join(s)))
                        self.check_password(w)
                            #if len(w) < 10 :
                            #for word in map(''.join, itertools.product(*((c.upper(), c.lower()) for c in w))) :
                            #self.check_password(word)
    
    def dictionnary_nouns_cat(self):
    
        list_common = ['time', 'year', 'people','way', 'day','man', 'thing', 'woman', 'life', 'child', 'world', 'school', 'state', 'family', 'student', 'group', 'country', 'problem', 'hand', 'part', 'place', 'case', 'week', 'company', 'system', 'program', 'question', 'work', 'government', 'number','night', 'point', 'home', 'water', 'room', 'mother', 'area', 'money', 'story', 'fact', 'month', 'lot', 'right', 'study', 'book', 'eye', 'job', 'word', 'business', 'issue', 'side', 'kind', 'head', 'house', 'service', 'friend', 'father', 'power', 'hour', 'game', 'line', 'end', 'member', 'law', 'car', 'city', 'community', 'name', 'president', 'team', 'minute', 'idea', 'kid', 'body', 'information', 'back', 'parent', 'face', 'others', 'level', 'office', 'door', 'health', 'person', 'art', 'war', 'history', 'party', 'result', 'change', 'morning', 'reason', 'research', 'girl', 'guy', 'moment', 'air', 'teacher', 'force', 'education']
        
        for word1 in list_common :
            self.check_password(word1)
            
            for r in range(1,5) :
                for s in itertools.product(list_common, repeat=r):
                    self.check_password(''.join(s))
                        #for word in map(''.join, itertools.product(*((c.upper(), c.lower()) for c in ''.join(s)))) :
                            #self.check_password(''.join(word))

                   
    def dictionnary_nouns_diceware(self):
        
        list_common = ['time', 'year', 'people','way', 'day','man', 'thing', 'woman', 'life', 'child', 'world', 'school', 'state', 'family', 'student', 'group', 'country', 'problem', 'hand', 'part', 'place', 'case', 'week', 'company', 'system', 'program', 'question', 'work', 'government', 'number','night', 'point', 'home', 'water', 'room', 'mother', 'area', 'money', 'story', 'fact', 'month', 'lot', 'right', 'study', 'book', 'eye', 'job', 'word', 'business', 'issue', 'side', 'kind', 'head', 'house', 'service', 'friend', 'father', 'power', 'hour', 'game', 'line', 'end', 'member', 'law', 'car', 'city', 'community', 'name', 'president', 'team', 'minute', 'idea', 'kid', 'body', 'information', 'back', 'parent', 'face', 'others', 'level', 'office', 'door', 'health', 'person', 'art', 'war', 'history', 'party', 'result', 'change', 'morning', 'reason', 'research', 'girl', 'guy', 'moment', 'air', 'teacher', 'force', 'education']
        
        for word1 in list_common :
            
            for r in range(1,6) :
                for s in itertools.product(list_common, repeat=r):
                    self.check_password('-'.join(s))
    
    def dictionnary_words(self):
        
        files = ['google-10000-english-no-swears.txt', 'google-10000-english-usa-no-swears-long.txt', 'google-10000-english-usa-no-swears-medium.txt', 'google-10000-english-usa-no-swears-short.txt', 'google-10000-english-usa-no-swears.txt', 'google-10000-english-usa.txt', 'google-10000-english.txt', '20k.txt']

        for file in files :
            with open("/Users/maelfabien/TelecomParisTech/INF344/google/" + file) as infile:
                for password in infile:
                    print(password[:-1])
                    self.check_password(password[:-1])

    
    def dictionnary_words_leet(self):
        def leet(word):
            leet_matches = [['a', '@'],
                    ['b'],
                    ['c'],
                    ['d'],
                    ['e', '3'],
                    ['f'],
                    ['g'],
                    ['h'],
                    ['i', '1'],
                    ['j'],
                    ['k'],
                    ['l', '1'],
                    ['m'],
                    ['n'],
                    ['o', '0'],
                    ['p'],
                    ['q'],
                    ['r'],
                    ['s'],
                    ['t'],
                    ['u'],
                    ['v'],
                    ['w'],
                    ['x'],
                    ['y'],
                    ['z']]
            l = []
            for letter in word:
                for match in leet_matches:
                    if match[0] == letter:
                        l.append(match)
            res = list(itertools.product(*l))
            [self.check_password(''.join(r)) for r in res]
            pass

        with open("/Users/maelfabien/TelecomParisTech/INF344/google/20k.txt") as infile:
            for password in infile:
                leet(password[:-1])

    def social_google(self):
        psw = 'Thal3s'
        name = 'John'
        last = 'Doe'
        
        num = ['0','1','2','3','4','5','6','7','8','9']
        for r in range(1,3) :
            for s in itertools.product(num, repeat=r):
                w = ''.join(str(psw) + str(''.join(s)))
                self.check_password(w)

    def social_jdoe(self):
        
        like = ['thales', 'Thales',  'john','John', 'doe', 'Doe', 'juneau', 'Juneau','alaska', 'Alaska','redsox','RedSox', '8', '14', '84', '1984', '08', 'jack', 'Jack', 'husky']
        
        wife = ['jane', 'Jane', 'smith', 'Smith', '5', '7', '05', '07', '10', '2010']
        
        girl = ['marie', 'Marie', '01', '15', '11', '1', '2011']
        
        wife_girl = ['jane', 'Jane', 'smith', 'Smith', '5', '7', '05', '07', '10', '2010', 'marie', 'Marie', '01', '15', '11', '1', '2011']
        
        dates = ['5', '7', '05', '07', '10', '2010', '01', '15', '11', '1', '2011']
    
        with open("/Users/maelfabien/TelecomParisTech/INF344/google/20k.txt") as infile:
            for word in infile:
                for s in itertools.product(wife_girl, repeat=3):
                    w = ''.join(str(str(word[:-1]) + ''.join(s)))
                    self.check_password(w)
                    self.check_password(w.capitalize())


        with open("/Users/maelfabien/TelecomParisTech/INF344/psw.txt") as infile:
            for word in infile:
                for s in itertools.product(wife_girl, repeat=3):
                    w = ''.join(str(str(word[:-1]) + ''.join(s)))
                    self.check_password(w)
                    self.check_password(w.capitalize())

    def social_jdoe1(self):
        
        like = ['thales', 'Thales',  'john','John', 'doe', 'Doe', 'juneau', 'Juneau','alaska', 'Alaska','redsox','RedSox', '8', '14', '84', '1984', '08', 'jack', 'Jack', 'husky']

        wife = ['jane', 'Jane', 'smith', 'Smith', '5', '7', '05', '07', '10', '2010']

        girl = ['marie', 'Marie', '01', '15', '11', '1', '2011']

        wife_girl = ['jane', 'Jane', 'smith', 'Smith', '5', '7', '05', '07', '10', '2010', 'marie', 'Marie', '01', '15', '11', '1', '2011']
        
        dates = ['5', '7', '05', '07', '10', '2010', '01', '15', '11', '1', '2011']
        
        with open("/Users/maelfabien/TelecomParisTech/INF344/google/20k.txt") as infile:
            for word in infile:
                for s in itertools.product(dates, repeat=3):
                    w = ''.join(str(word[:-1]) + str(''.join(s)))
                    self.check_password(w)
                    self.check_password(w.capitalize())

        with open("/Users/maelfabien/TelecomParisTech/INF344/psw.txt") as infile:
            for word in infile:
                for s in itertools.product(dates, repeat=3):
                    w = ''.join(str(word[:-1]) + str(''.join(s)))
                    #print(w)
                    self.check_password(w)
                    self.check_password(w.capitalize())

    def social_jdoe_2(self):
        
        info = ['Thal3s', 'Thales1', 'Thales', 'John', 'Doe', '8', '14','1984', 'Juneau', 'Alaska', 'RedSox', 'Jane', 'Smith', '5', '7', '2010', '05', '07', '08', 'Marie', '01', '1', '15', '2011', '11', 'Jack', 'dog', 'jack', 'marie', 'smith', 'jane', 'redsox', 'alaska', 'juneau', 'doe', 'john', 'thales']
        
        info2 = ['thales', 'john', 'doe', '8-14-1984', '08-14-1984', '08-14-84', 'juneau', 'alaska', 'redsox', 'jane', 'smith', '5-7-2010', '05-07-2010', 'marie', '01-15-2011', '1-15-11', 'jack']
        
        like = ['thales', 'Thales',  'john','John', 'doe', 'Doe', 'juneau', 'Juneau','alaska', 'Alaska','redsox','RedSox', '8', '14', '84', '1984', '08', 'jack', 'Jack', 'husky']
        wife = ['jane', 'Jane', 'smith', 'Smith', '5', '7', '05', '07', '10', '2010']
        girl = ['marie', 'Marie', '01', '15', '11', '1', '2011']
        wife_girl = ['jane', 'Jane', 'smith', 'Smith', '5', '7', '05', '07', '10', '2010', 'marie', 'Marie', '01', '15', '11', '1', '2011']
        
        for word in info :
            
            for r in range(1,6) :

                for s in itertools.product(like, repeat=r):
                    self.check_password(''.join(s))
                for s in itertools.product(wife, repeat=r):
                    self.check_password(''.join(s))
                for s in itertools.product(girl, repeat=r):
                    self.check_password(''.join(s))
                for s in itertools.product(wife_girl, repeat=r):
                    self.check_password(''.join(s))

                for s in itertools.product(like, repeat=r):
                    self.check_password('-'.join(s))
                for s in itertools.product(wife, repeat=r):
                    self.check_password('-'.join(s))
                for s in itertools.product(girl, repeat=r):
                    self.check_password('-'.join(s))
                for s in itertools.product(wife_girl, repeat=r):
                    self.check_password('-'.join(s))

def get_passwords(filename):
    """get_passwords
    Get the passwords from a file
    :param filename: The name of the file which stores the passwords
    :return: The set of passwords
    """
    passwords = set()
    with open(filename, "r") as f:
        for line in f:
            passwords.add(line.strip())
    return passwords


if __name__ == "__main__":
    name = "fabien".lower()
    # This is the correct location on the moodle
    #encfile = "../passwords/" + name + ".enc"
    
    # If you run the script on your computer: uncomment and fill the following 
    # line. Do not forget to comment this line again when you submit your code
    # on the moodle.
    encfile = "/Users/maelfabien/TelecomParisTech/INF344/fabien.enc"
    
    # First argument is the password file, the second your name
    crack = Crack(encfile, name)
    crack.crack()
    if "--eval" in sys.argv: crack.evaluate()
