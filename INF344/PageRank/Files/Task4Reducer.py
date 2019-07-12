#!/usr/bin/python3
import sys
import json

current_key = None

#sol contains a dictonnary title->set of links
sol = {}

for line in sys.stdin:
    word, rawdata = line.strip('\n').split("\t",1)
    if word not in sol and rawdata != 'exists' :
        #TODO initialize the set
        sol[word] = {rawdata}
    elif rawdata == 'exists' :
        sol[word].add(None)
    else :
        sol[word].add(rawdata)

#TODO populate the set...
for key in sorted(sol.keys()):
    list_key = list(sol[key])
    list_key = [i for i in list_key if i]
    value = sorted(list_key)
    score_link = {"score" : 1, "links" : value}
    print(key+"\t"+json.dumps(score_link))
