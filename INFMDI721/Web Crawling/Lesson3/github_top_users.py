from bs4 import BeautifulSoup
import requests
import pandas as pd
import numpy as np
import requests
import json
from github import Github
from flask import jsonify

web_link = "https://gist.github.com/paulmillr/2657075"

def get_names(link):

    soup = BeautifulSoup(requests.get(link).text, "html.parser")

    table = soup.find("table")
    table_data = table.find_all("td")
    data = []

    for info in table_data :
        data.append(info.text)


    table_data = pd.DataFrame(np.array(data).reshape(256,4), columns=['Name', 'Contributions', 'Location', 'ToDrop'])
    table_data = table_data.drop(['ToDrop'], axis=1)

    #We are only interested in the username
    listnames = table_data.Name.str.split().str.get(0)
    return listnames

def get_data_for_user(listnames) :

    df = []

    for name in listnames :
        username = name
        token = "********************"

        nb_repos = len(requests.get('https://api.github.com/users/' + name + '/repos?per_page=2000', auth=(username, token)).json())

        repo = requests.get('https://api.github.com/users/' + name + '/repos?per_page=2000', auth=(username, token)).json()

        i = 0
        count_stars = 0

        while i < nb_repos :
            repository = int(repo[i]['stargazers_count'])
            count_stars = count_stars + repository
            i += 1

        if (nb_repos != 0) :
            user_average = count_stars/nb_repos
        else :
            user_average = 0

        array = [name, user_average]
        df.append(array)

    print(pd.DataFrame(data = df, columns = ['Name', 'Average']).sort_values(by=['Average']))

def main():
    get_data_for_user(get_names(web_link))

if __name__ == "__main__":
   main()