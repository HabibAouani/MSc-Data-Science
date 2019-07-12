#!/usr/bin/python3
import sys

current_key = None

#sol contains a dictonnary title->set of links
sol = {}
for line in sys.stdin:
    word, rawdata = line.strip('\n').split("\t",1)
    if word not in sol:
        sol[word] = {rawdata}
    else:
        sol[word].add(rawdata)

for key in sorted(sol.keys()):
    list_links = sorted(list(sol[key]))
    list_links.remove("exists")
    if len(list_links) == 0:
        print(key+"\t")
    else:
        print(key+"\t"+ ",".join(list_links))
