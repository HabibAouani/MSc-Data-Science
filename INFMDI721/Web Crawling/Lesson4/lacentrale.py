import requests
from bs4 import BeautifulSoup
import pandas as pd
import re
from numpy import mean

website_prefix = "https://www.lacentrale.fr/listing?makesModelsCommercialNames=RENAULT%3AZOE&options=&page="
regions = "&regions=FR-PAC%2CFR-IDF%2CFR-NAQ"
res = requests.get(website_prefix)
html_doc = res.text
soup = BeautifulSoup(html_doc,"html.parser")

#Find total number of pages to scroll over
number = int(((soup.find_all("span", class_="numAnn")[0]).text).replace(u'\xa0', u''))
nbpages = int((number/16))

link1 = []
link2 = []

i = 1

#Scrap 25 pages only (otherwise process is really long)
while i < 2 :
    url_page = website_prefix + str(i) + regions

    res = requests.get(url_page)
    html_doc = res.text
    soup = BeautifulSoup(html_doc, "html.parser")

    data_full = []

    link1.extend(list(map(lambda x: x['href'], soup.find_all("a", class_="linkAd ann"))))
    link2.extend(list(map(lambda x: x['href'], soup.find_all("a", class_="linkAd annJB"))))

    for page in (link1 or link2) :
        prefix = "https://www.lacentrale.fr/"
        url2 = prefix + str(page)

        data = []
        soup = BeautifulSoup(requests.get(url2).text, "html.parser")

        table = soup.find("ul", class_="infoGeneraleTxt column2")
        table_data = table.find_all("span")

        version = ((soup.find("h3", class_="mL20 clearPhone").text).split("- ")[1]).replace("                \n", "")
        seller = (soup.find("h3", class_="mB10 noBold").text).split("Dpt.")[0].replace("\n\n                ","").replace("            ", "")
        seller_dpt = (soup.find("h3", class_="mB10 noBold").text).split("Dpt.")[1].replace("\n                ","").replace("            \n","")
        phone = re.sub("[^0-9]", "", soup.find("div", class_="phoneNumber1").text)
        num_annonce = re.sub("[^0-9]", "", soup.find("span", class_="pW10 bGreyCL b0Phone txtGrey6 clearPhone").text)
        prix = re.sub("[^0-9]", "", soup.find("strong", class_="sizeD lH35 inlineBlock vMiddle ").text)
        brand = re.sub('[^a-zA-Z]+', '', soup.find("div", class_="sizeD").text.split("                        ")[1])
        model = re.sub('[^a-zA-Z]+', '', soup.find("div", class_="sizeD").text.split("                        ")[2])
        pro = soup.find("div", class_="bold italic mB10").text.replace("\n                                            ","").split(" ")[0]

        data.append(brand)
        data.append(model)
        data.append(version)
        data.append(seller)
        data.append(seller_dpt)
        data.append(num_annonce)
        data.append(phone)
        data.append(prix)
        data.append(pro)

        for info in table_data:
            data.append(info.text)

        data[9] = re.sub("[^0-9]", "", data[9])
        data[10] = re.sub("[^0-9]", "", data[10])
        data[11] = re.sub("[^0-9]", "", data[11])
        data[12] = re.sub("[^0-9]", "", data[12])
        data[13] = re.sub("[^0-9]", "", data[13])
        data[16] = data[16].replace("\xa0/\xa0", "/")

        data_full.append(data)

    i = i + 1

#Stack results in a DataFrame
df = pd.DataFrame(data_full)
#Reorganize DF :
df2 = pd.DataFrame()
#columns=['Year', 'Mileage(km)', 'NbDoors', 'Power(CV)', 'Power(ch)', 'Gear', 'Energy', 'DateCirculation', 'Color', 'FirstHand', 'Warranty', 'Brand', 'Model', 'Version', 'Seller', 'Department', 'NAnnounce', 'Phone', 'Price(€)', 'Professional']
df2['Brand'] = df[0]
df2['Model'] = df[1]
df2['Version'] = df[2]
df2['Seller'] = df[3]
df2['Department'] = df[4]
df2['N°Ann'] = df[5]
df2['Phone'] = df[6]
df2['Price(€)'] = pd.to_numeric(df[7])
df2['Pro'] = df[8]
df2['Year'] = df[9]
df2['Mileage(km)'] = df[10]
df2['Doors'] = df[11]
df2['CV'] = df[12]

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
    #print(table_data)
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
#print(cote_ovrll)

df2['argus'] = pd.to_numeric(df2['Year'].map(cote_ovrll))
df2['diff'] = df2['Price(€)'] - df2['argus']

print(df2)

#writer = pd.ExcelWriter('data_zoe.xlsx')
#df2.to_excel(writer, sheet_name='Sheet1')
#writer.save()