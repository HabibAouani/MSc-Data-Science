#!/usr/bin/python3

import sys
import json

damping=0.85
sol={}
updated={}

for line in sys.stdin:
    word, rawdata = line.strip('\n').split("\t",1)
    data = json.loads(rawdata)
    
    if word not in sol :
        sol[word] = {}
        sol[word]['score'] = []
        updated[word] = 0
        
        if data['existenceSignal'] is True :
            updated[word] = 1
            sol[word]['links'] = data['links']
        else :
            sol[word]['score'].append(damping * data['score']/data['nLinks'])
    else :
        if data['existenceSignal'] is True :
            sol[word]['links'] = data['links']
            updated[word] = 1
        else :
            sol[word]['score'].append(damping * data['score']/data['nLinks'])


for w in sorted(sol.keys()):
    if updated[w] == 1 :
        sol[w]['score'] = 1 - damping + sum(sol[w]['score'])
    
        print(w+"\t"+json.dumps(sol[w]))

# ...
#        print(w+"\t"+json.dumps(sol[w]))
