#!/usr/bin/python3

iterations = 1000000
damping = 0.85

links = {}
pages = []

for line in sys.stdin:
    word, rawdata = line.strip('\n').split("\t",1)
    data = json.loads(rawdata)
    pages.append(word)
    links[word] = data["links"]

page = random.choice(pages)
print(page+"\t"+"1")
for i in range(0, max_i):
    d = random.random()
    if d < 1 - damping:
        page = random.choice(pages)
        print(page+"\t"+"1")
    else:
        if len(links[page]) > 0:
            page = random.choice(links[page])
            print(page+"\t"+"1")
        else:
            page = random.choice(pages)
            print(page+"\t"+"1")
