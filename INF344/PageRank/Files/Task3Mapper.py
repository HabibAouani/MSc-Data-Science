#!/usr/bin/python3
#inspired by https://github.com/RobertHosking/WikiLinks-Parse/blob/master/text_parser.py
import sys
import xml.etree.ElementTree as ET
import re

ns={'svg':'{http://www.w3.org/2000/svg}', 'mediawiki':'{http://www.mediawiki.org/xml/export-0.10/}'}



#allows you to test the mapper with ./Mapper.py file.xml without using hadoop
if len(sys.argv)>1:
    tree=ET.parse(sys.argv[1])
else:
    tree=ET.parse(sys.stdin)


root=tree.getroot()


#for every page
for page in root.findall('{http://www.mediawiki.org/xml/export-0.10/}page',ns):
    title=page.find('{http://www.mediawiki.org/xml/export-0.10/}title',ns).text
    if (title == None) or (title == "") or (':' in title) or (',' in title) or ('&' in title) or(title[0]=='#'):
        continue
    rev=page.find('{http://www.mediawiki.org/xml/export-0.10/}revision',ns)
    if rev == None or title == None:
        continue
    text =rev.find('{http://www.mediawiki.org/xml/export-0.10/}text',ns).text
    if (text == None) or (text=="") or (text=="None"):
        continue

    # The page exists ! (with title "title")
    print(title+"\t"+"exists")

    links=re.findall(r'\[\[([^\]]*?)\]\]', text)

    #for every link
    for link in links:
        if (link == None) or (link == "") or (':' in link) or (',' in link) or ('&' in link) or (link[0] == "#" or "\n" in link):
            continue
        link = link.split("|")[0]
        link = link.split("#")[0]
        if len(link) > 0:
            #prints the page title, a tab, and the link name
            print(title+"\t"+link)
