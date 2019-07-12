#!/usr/bin/python3                                     
import sys

def main(argv):
    current_word = None
    wordcount = 0
    for line in sys.stdin:
        word, n = line.strip().split("\t",1)
        n = int(n)
        if current_word == word:
            wordcount += n
        else:
            if current_word:
                print(current_word+"\t"+str(wordcount))
            wordcount = n
            current_word = word
    print(current_word+"\t"+str(wordcount))
if __name__ == "__main__":
     main(sys.argv)

