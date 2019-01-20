from bs4 import BeautifulSoup
import requests
import pandas as pd

def main():
    url = "https://www.darty.com/nav/achat/informatique/ordinateur_portable/portable/marque__hp__HP.html"
    datas = []
    result = requests.get(url)
    html_doc = result.text
    soup = BeautifulSoup(html_doc, "html.parser")
    #pages = range(10)
    df = pd.DataFrame()
    datas = soup.find_all("p", class_="darty_prix_barre_remise darty_small separator_top")
    for data in datas :
        data.replace("- ", "").replace("%", "")
    #url = web_link + value + ".html"
    moyenne = datas.sum()/len(datas)
    return moyenne

if __name__ == "__main__":
    main()