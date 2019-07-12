{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf400
{\fonttbl\f0\fnil\fcharset0 Verdana;}
{\colortbl;\red255\green255\blue255;\red26\green26\blue26;\red255\green255\blue255;}
{\*\expandedcolortbl;;\cssrgb\c13333\c13333\c13333;\cssrgb\c100000\c100000\c100000;}
\paperw11900\paperh16840\margl1440\margr1440\vieww13540\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\sl300\partightenfactor0

\f0\fs24 \cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Le r\'f4le g\'e9n\'e9ral d'une m\'e9thode comme linksfilter dans une application de crawling :\
- Les m\'e9thodes comme links filter permettent de r\'e9duire le nombre de liens que l\'92on consid\'e8re\
- Cela permet d\'92\'e9liminer les redirections que l\'92on retrouve souvent sur un site (e.g liens de partage Twitter)\
- Cela permet \'e9galement d\'92\'e9viter d\'92explorer deux fois un m\'eame lien\
\
Le r\'f4le g\'e9n\'e9ral d'une m\'e9thode comme contentfilter dans une application de crawling et les limites du code propos\'e9 \'e0 l'\'e9tape 6 :\
- Les m\'e9thodes comme content filter permettent de s\'e9lectionner uniquement les liens qui contiennent des informations susceptibles de nous int\'e9resser.\
- Il existe trois limites majeures :\
	- une page peut contenir un mot cl\'e9 comme Inventors sans pour autant contenir l\'92information que l\'92on cherche initialement\
	- cela implique que l\'92on connaisse \'e0 l\'92avance les mots cl\'e9s que l\'92on cherche ou l\'92information exacte que l\'92on cherche, \
	- le code n\'92est pas portable sur une version dans une langue diff\'e9rente, ou sur un autre site\
}