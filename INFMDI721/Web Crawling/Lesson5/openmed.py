from bs4 import BeautifulSoup
import requests
import pandas as pd
import numpy as np
import requests
import json
from github import Github
from flask import jsonify
from pandas.io.json import json_normalize
from sqlalchemy import null
import re
desired_width = 320
pd.set_option('display.width', desired_width)

med = requests.get("https://www.open-medicaments.fr/api/v1/medicaments?limit=100&query=paracetamol").json()
df = pd.DataFrame(med)['denomination']

reg = r'([\D]*)(\d+)(.*),(.*)'
df = df.str.extract(reg)
df["mul"] = 1000

df["mul"]=df["mul"].where(df[2].str.strip()=="g",1)
df["dosage"]=df[1].fillna(0).astype(int)*df["mul"]
print(df)

ICS =[f"https://www.open-medicaments.fr/api/v1/medicaments/"{elem}]

requests.get(ICS[0]).json()["presentations"][0]["libelle"]
#i = 0
#medlist = []
#while i < 100 :
    #medlist.append(med[i]['codeCIS'])
    #print(medlist)
    #i = i+1

#print(med['codeCIS'])

#for medicament in medlist :
    #info = requests.get("https://www.open-medicaments.fr/api/v1/medicaments/66643680").json()['presentations']
    #info2 = info['libelle']
    #print(info2['libelle'])
    #print(info)
    #data = json.loads(info)
    #dosage = json_normalize(data['libelle'])
    #print(data)
    #dosage2 = re.sub("[^0-9]", "",dosage)
    #print(dosage)

#print(med['codeCIS'])

