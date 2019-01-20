from bs4 import BeautifulSoup
import re
import requests
import pandas as pd

web_link = "https://www.reuters.com/finance/stocks/financial-highlights/"
company = {"Airbus": "AIR", "Danone": "DANO", "LVMH": "LVMH"}

def url_to_soup(link):
    result = requests.get(link)
    if result.status_code == 200:
        html_doc = result.text
        soup = BeautifulSoup(html_doc, "html.parser")
        return soup

def string_op2(string):
    char_list = ["\t", "\n", "\r", " ", "(", ")"]
    return re.sub("|".join(char_list), "", string)

def get_data(soup, company):
    quarter_sales = soup.find(class_="stripe").text.split("\n")[3]
    share_price = string_op2(soup.find("div", class_="sectionQuote nasdaqChange").findAll("span")[1].text)
    price_change = string_op2(
        soup.find("div", class_="sectionQuote priceChange").find(class_="valueContentPercent").text)[1:-1]
    company_div_yield = soup.find("td", text="Dividend Yield").parent.text.split("\n")[2]
    sector_div_yield = soup.find("td", text="Dividend Yield").parent.text.split("\n")[3]
    industry_div_yield = soup.find("td", text="Dividend Yield").parent.text.split("\n")[4]
    shares_owned = soup.find("td", text="% Shares Owned:").parent.text.split("\n")[2:3]
    return {"Company": company,
            "1/4 Sales": quarter_sales,
            "Share Price": share_price,
            "Price Change": price_change,
            "Company Div. %": company_div_yield,
            "Sector Div. %": sector_div_yield,
            "Industry Div. %": industry_div_yield,
            "Inst.Shares": shares_owned[0]}

def main():
    df = pd.DataFrame()
    for value in company.values():
        url = web_link + value + ".PA"
        soup = url_to_soup(url)
        df2 = get_data(soup, value)
        df = df.append(df2, ignore_index=True)
    return df.to_csv('database_2_reuters.csv')

if __name__ == "__main__":
    main()