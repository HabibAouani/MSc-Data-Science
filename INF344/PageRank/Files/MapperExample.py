#!/usr/bin/python3
import sys
def main(argv):
  for line in sys.stdin:
    wordlist = line.strip().split()
    for word in wordlist:
      print(word+"\t"+"1")
if __name__ == "__main__":
  main(sys.argv)
