### Analyse des correspondances ###

# Les lignes correspondent à des disciplines olympiques, les colonnes à des pays.
data(JO)
library(ade4)
library(FactoMineR)

?JO

# On vérifie qu’il y a bien 15 médailles par discipline
apply(JO, 1, sum)

# La fonction CA de FactoMineR effectue par défaut un test du X2
resJO <- CA(JO)
summary(resJO)

# L'hypothèse d'indépendance est rejetée car p-value = 2.32e-41. 
# Mais nij > 5 pour chaque paire (i,j) pas satisfait.

## Profils lignes
rowprof <- JO / apply(JO, 1, sum)
apply(rowprof,1,sum)
## Profils colonnes
colprof <- t(t(JO) / apply(JO, 2, sum)) #t() : transposee
apply(colprof,2,sum)

# Q1 : Inspectez les valeurs propres de l’AC.
round(resJO$eig,1)

# La variance cumulée progresse bien plus lentement. Il faudrait 5 dimensions pour garder 50% de la variance.

# Q2 : Vérifiez que l’inertie totale vaut 1/n × la statistique du X2. 
# On accède directement à cette dernière via la fonction chisq.test

chisq.test(JO)
2122.2/sum(JO)

# Inertie totale : 
sum(resJO$eig[1:23])

# Q3 : . Les coordonnées des profils lignes sur les axes principaux sont accessibles via
resJO$row$coord

# Vérifiez que le barycentre des projections des profils lignes sur les deux premiers axes est le vecteur nul,
# lorsque l’on utilise comme poids les fréquences marginales, obtenues comme ceci :
n <- sum(JO)
rowW <- apply(JO,1,sum)/n
rowW
colW <- apply(JO,2,sum)/n
colW

mean(rowW*resJO$row$coord[1:48])

# Q4 : Vérifiez que la variance pondérée des coordonnées des lignes sur le premier axe est égale à la première valeur propre.

sum(t(rowW)*resJO$row$coord[,1]^2)
resJO$eig

# Q5 : Vérifiez que la corrélation entre les vecteurs des coordonnées des profils lignes 
# projetées sur l’axe 1 et l’axe 2 est nulle. Justifiez théoriquement ce résultat.
cor(resJO$row$coord[,1], resJO$row$coord[,2])
# Proche de 0

# Q6: Calculez les contributions des profils lignes à l’axe 1 en utilisant les poids rowW, 
# les coordonnées des lignes resJO$row$coord et les valeurs propres resJO$eig[,1].

resJO$row$contrib








