import requests
import unittest
from bs4 import BeautifulSoup
import pandas as pd

website_prefix = "https://www.reuters.com/finance/stocks/financial-highlights/"
stock_mkt = "PA"
stock_name = ['AIR', 'LVMH', 'DANO']

df = []

for j in stock_name :

    def _handle_request_result_and_build_soup(request_result):
        if request_result.status_code == 200:
            html_doc =  request_result.text
            soup = BeautifulSoup(html_doc,"html.parser")
        return soup

    url = website_prefix + j + "." + stock_mkt
    res = requests.get(url)
    soup = _handle_request_result_and_build_soup(res)

    data = []
    sp = []
    change_per = []

    print((((((soup.find("span", class_="valueContent")).text).replace("\n", "").replace("	    						    ", "")).replace("€", "")).split("					            ")[0]))

    data.extend(list(map(lambda x: (((x.text).replace(",", "")).replace("--", "0")), soup.find_all("td", class_="data"))))
    change_per.extend(list(map(lambda x: x.split("\t"), (((((soup.find("span", class_="valueContent")).text).replace("\n", "").replace("	    						    ", "")).replace("€", "")).split("					            ")[0]))))
    sp.extend(list(map(lambda x: (((x.text).replace("\n\n\t\t\t\t", "")).replace("EUR", "")).split("\n"), soup.find_all("div", class_="sectionQuoteDetail"))))
    print(change_per)
    #Sales
    num_estimates = float(data[1])
    mean_sales = float(data[2])
    high_sales = float(data[3])
    low_sales = float(data[4])
    year_ago_sales = float(data[5])

    #Stock price
    stock_price = float(sp[0][1])
    #Change in price
    change_price = change_per[0]

    shares_owned_company = float(data[69])
    shares_owned_industry = float(data[70])
    shares_owned_sector = float(data[71])

    #Dividends
    dividend_company = float(data[72])
    dividend_sector = float(data[73])
    dividend_industy = float(data[74])
    print(change_per)
    df.append([j, stock_mkt, stock_price, change_price, num_estimates, mean_sales, high_sales, low_sales, year_ago_sales, shares_owned_company, shares_owned_industry, shares_owned_sector, dividend_company, dividend_industy, dividend_sector])

table = pd.DataFrame(df, columns=['Stock Name', 'Market', 'Stock Price', 'Change in Price', '#Nb Estimates', 'Mean Sales (Mln)', 'High Sales', 'Low Sales', 'Sales 1y. ago', '% Owned Institutions Company', '% Owned Institutions Industry', '% Owned Institutions Sector', 'Dividend Rate Company', 'Dividend Rate Industry', 'Dividend Rate Sector'])
table.to_csv('database_reuters.csv')
print(table.head())

with pd.option_context('display.max_rows', None, 'display.max_columns', None):
    print(table)
