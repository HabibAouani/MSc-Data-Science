#!/usr/bin/python3
import sys
import json

sol={}

for line in sys.stdin:
    word, rawdata = line.strip('\n').split("\t",1)
    data = json.loads(rawdata)
    
    if word not in sol:
        sol[word] = 1
    else:
        sol[word] += 1

tot = sum(sol.values())

for key in sorted(sol.keys()):
    score = (sol[key] / tot) * len(sol)
    print(key+"\t"+str(score))
