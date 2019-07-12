#!/usr/bin/python3                                     
import sys

current_key = None

#sol contains a dictonnary title->set of links
sol = {}

for line in sys.stdin:
    word, rawdata = line.strip('\n').split("\t",1)
    if word not in sol:
        #TODO initialize the set
        sol[word] = {rawdata}
    else :
        
        sol[word].add(rawdata)

    #TODO populate the set...
for key in sorted(sol.keys()):
    value = sorted(list(sol[key]))
    print(key+"\t"+','.join(value))
