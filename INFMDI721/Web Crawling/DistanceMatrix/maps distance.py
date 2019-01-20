from bs4 import BeautifulSoup
import requests
import pandas as pd
import numpy as np
import requests
import json
from github import Github
from flask import jsonify

link = "https://fr.wikipedia.org/wiki/Liste_des_communes_de_France_les_plus_peupl%C3%A9es"
def get_names(link):

    soup = BeautifulSoup(requests.get(link).text, "html.parser")

    table = soup.find("table")
    table_data = table.find_all("a")
    data = []

    for info in table_data :
        data.append(info.text)

    table_data = pd.DataFrame(data)
    table_data = pd.DataFrame(np.array(table_data).reshape(211, 4), columns=['Name', 'Contributions', 'Location', 'ToDrop'])

    print(table_data)

def get_distances(city1, city2):

    web_link = "https://www.google.fr/maps/dir/" + city1 + "/" + city2 + "/"

    soup = BeautifulSoup(requests.get(web_link).text, "html.parser")
    distance = soup.find_all('div', class_='7.section-directions-trip-duration,7.delay-light')

    return distance

get_names(link)