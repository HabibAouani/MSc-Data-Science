# -*- coding: utf-8 -*-
# écrit par Jean-Claude Moissinac, structure du code par Julien Romero

from sys import argv
import sys
import urllib
from bs4 import BeautifulSoup
import time
import re

if (sys.version_info > (3, 0)):
    from urllib.request import urlopen
    from urllib.parse import urlencode
else:
    from urllib2 import urlopen
    from urllib import urlencode

class Collecte:
    """pour pratiquer plusieurs méthodes de collecte de données"""
    
    def __init__(self):
        """__init__
            Initialise la session de collecte
            :return: Object of class Collecte
            """
        # DO NOT MODIFY
        self.basename = "collecte.step"
    
    def collectes(self):
        """collectes
            Plusieurs étapes de collectes. VOTRE CODE VA VENIR CI-DESSOUS
            COMPLETER les méthodes stepX.
            """
        #self.step0()
        self.step1()
        self.step2()
        self.step3()
        self.step4()
        self.step5()
        self.step6()
    
    
    def step1(self):
        stepfilename = self.basename+"1"
        result = ""
        # votre code ici
        req = urllib.request.Request("http://www.freepatentsonline.com/result.html?sort=relevance&srch=top&query_txt=video&submit=&patents=on")
        
        with urllib.request.urlopen(req) as response:
            result = str(response.read())
        
        with open(stepfilename, "w", encoding="utf-8") as resfile:
            resfile.write(result)
    

    def step2(self):
        stepfilename = self.basename+"2"
        
        result = ""
        # votre code ici
        
        links = []
        resfile = open(self.basename+"1", 'r').read()
        soup = BeautifulSoup(resfile, 'html.parser')
        
        for link in soup.findAll('a') :
            links.append(str(link.get('href')))
    
        result = "\n".join(links)
        
        with open(stepfilename, "w", encoding="utf-8") as resfile:
            resfile.write(result)

    def linksfilter(self, links):
        
        links = sorted(set(links))
        
        rmv = ['None', '/', '/services.html', '/contact.html', '/privacy.html', '/register.html', '/tools-resources.html', 'https://twitter.com/FPOCommunity', 'http://www.linkedin.com/groups/FPO-Community-4524797', 'http://www.sumobrainsolutions.com/']
        
        links_filter = []
        
        for l in links :
            if not l in rmv and not l.startswith("\\'result.html") and not l.startswith('http://research') and not l.startswith('/search.html') :
                links_filter.append(l)
        
        return links_filter

    def step3(self):
        
        stepfilename = self.basename+"3"
        result = ""
        
        result = self.linksfilter(open(self.basename+"2", 'r').read().splitlines())
        print("Step 3 : " + str(len(result)) + " results.")
        
        result = "\n".join(result)
        
        # votre code ici
        with open(stepfilename, "w", encoding="utf-8") as resfile:
            resfile.write(result)
        
        return result
    
    def step4(self):
        
        stepfilename = self.basename+"4"
        result = ""
        
        resfile =  list(open(self.basename+"3", "r", encoding="utf-8").read().splitlines())[:10]
        res = []
        
        for link in resfile :
            
            req = urllib.request.Request('http://www.freepatentsonline.com/' + str(link))

            with urllib.request.urlopen(req) as response:
                result = str(response.read())
        
            soup = BeautifulSoup(result, 'html.parser')
            
            links = []

            for link in soup.findAll('a') :
                links.append(str(link.get('href')))
    
            result = "\n".join(self.linksfilter(links))
        
            res.append(result)
            time.sleep(1)

        print("Step 4 : " + str(len(res)) + " results.")
        res = '\n'.join(sorted(set(res)))
        
        # votre code ici
        with open(stepfilename, "w", encoding="utf-8") as resfile:
            resfile.write(res)

    def contentfilter(self, link):
        
        
        soup = BeautifulSoup(link, 'html.parser')
        
        interest=[]
        
        inventors = soup.find_all(text=re.compile('Inventors:'))
        title = soup.find_all(text=re.compile('Title:'))
        application = soup.find_all(text=re.compile('Application Number:'))
        
        if inventors is not None and title is not None and application is not None :
            return True
        else :
            return False
    
    def step5(self):
        
        stepfilename = self.basename+"5"
        result = ""
        
        links=[]
        links_list =  list(open(self.basename+"4", "r", encoding="utf-8").read().splitlines())
        
        links_list_html = []
        
        for l in links_list:
            if l.endswith('html') :
                links_list_html.append(l)
    
        links_list_html = sorted(links_list_html)
        
        for link in links_list_html :

            if len(links) > 10 :
                break
            
            req = urllib.request.Request('http://www.freepatentsonline.com' + str(link))
            
            with urllib.request.urlopen(req) as response:
                result = str(response.read())
                
            soup = BeautifulSoup(result, 'html.parser')
                
            for div in soup.findAll('div') :
                inventors = div.find_all(text=re.compile('Inventors:'))
                title = div.find_all(text=re.compile('Title:'))
                application = div.find_all(text=re.compile('Application Number:'))
                if inventors is not None and title is not None and application is not None :
                            
                    links.append(link)
                    links = list(set(links))
                    if len(links) > 10 :
                        break
    
        print("Step 5 : " + str(len(links)) + " results.")
        
        results='\n'.join(sorted(set(links))[:10])
        
        # votre code ici
        with open(stepfilename, "w", encoding="utf-8") as resfile:
            resfile.write(results)

    def step6(self):
        stepfilename = self.basename+"6"
        result = ""
            # votre code ici
        
        links_list =  list(open(self.basename+"5", "r", encoding="utf-8").read().splitlines())[:5]
        inventors_list = []
        
        for link in links_list :
            req = urllib.request.Request('http://www.freepatentsonline.com' + str(link))
            
            with urllib.request.urlopen(req) as response:
                result = (response.read()).decode('utf-8')
            
            soup = BeautifulSoup(result, 'html.parser')

            inventors = soup.find_all(text=re.compile('Inventors:'))
            divs = [inventor.parent.parent for inventor in inventors]
        
            for d in divs[0].descendants:
                if d.name == 'div' and d.get('class', '') == ['disp_elm_text']:
                    inventors_list.append(d.text)
                    print(inventors_list)
        
        result = '\n'.join(inventors_list)
        print(result)
        with open(stepfilename, "w", encoding="utf-8") as resfile:
            resfile.write(result)

if __name__ == "__main__":
    collecte = Collecte()
    collecte.collectes()
