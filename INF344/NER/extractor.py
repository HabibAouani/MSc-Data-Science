'''Extracts type facts from a wikipedia file
usage: extractor.py wikipedia.txt output.txt

Every line of output.txt contains a fact of the form
    <title> TAB <type>
where <title> is the title of the Wikipedia page, and
<type> is a simple noun (excluding abstract types like
sort, kind, part, form, type, number, ...).

Note: the formatting of the output is already taken care of
by our template, you just have to complete the function
extractType below.

If you do not know the type of an entity, skip the article.
(Public skeleton code)'''

from parser import Parser
import sys
import re

import nltk
from nltk.tokenize import word_tokenize
from nltk.tag import pos_tag

if len(sys.argv) != 3:
    print(__doc__)
    sys.exit(-1)

def extractType(content):
    # Code goes here
    sent = nltk.word_tokenize(content)
    sent = nltk.pos_tag(sent)
    return sent

with open(sys.argv[2], 'w', encoding="utf-8") as output:
    for page in Parser(sys.argv[1]):
        print(extractType(page.content))
        typ = extractType(page.content)
        if typ:
            output.write(page.title + "\t" + typ + "\n")
