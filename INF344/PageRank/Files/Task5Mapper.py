#!/usr/bin/python3
import json
import sys

for line in sys.stdin:

    word, rawdata = line.strip('\n').split("\t",1)
    data = json.loads(rawdata)

    print(word+"\t"+json.dumps({"existenceSignal":True, "links":data["links"]}))
    
    for link in data["links"] :
        d={}
        d['from'] = word
        d['score'] = data['score']
        d['nLinks'] = len(data['links'])
        d['existenceSignal'] = False

        print(link +"\t"+json.dumps(d))
