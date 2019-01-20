import requests
from bs4 import BeautifulSoup
import re
import pandas as pd
from numpy import mean

web = "https://www.lacentrale.fr/cote-voitures-renault-zoe--"
web_suf = "-.html"

years = ['2012', '2013', '2014', '2015', '2016', '2017', '2018']

link_argus = []
cote = []
cote_ovrll = {}

for year in years :

    res = requests.get(web + str(year) + web_suf)
    html_doc = res.text
    soup = BeautifulSoup(html_doc, "html.parser")
    table_data = []

    table_data.extend(list(map(lambda x : "https://www.lacentrale.fr/" + (str(x).split('href="', 1)[1]).split('" ')[0], soup.find_all("div", class_="listingResultLine auto sizeA"))))
    print(table_data)
    link_argus.append(table_data)
    average = []

    for link in table_data :
        res2 = requests.get(link)
        html_doc2 = res2.text
        soup2 = BeautifulSoup(html_doc2, "html.parser")
        cote = int(re.sub("[^0-9]", "",soup2.find("span", class_="jsRefinedQuot").text))

        #cote = int(soup2.find("span", class_="jsRefinedQuot").text)
        #cote_ovrll.append({int(link[-9:-5]): cote})
        cote_ovrll[link[-9:-5]] = cote

    for key in cote_ovrll.keys() :
        cote_ovrll[key] = mean(cote_ovrll[key])

#print(link_argus)
print(cote_ovrll)