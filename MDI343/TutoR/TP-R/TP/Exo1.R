### ACP ###

#install.packages(c("ade4", "FactoMineR"))
library(ade4)
library(FactoMineR)

### Exercise 1 : Analyse en composantes principales des températures de villes d’europe
temperature <- read.table("http://factominer.free.fr/book/temperature.csv",
             header=TRUE,sep=";",dec=".",row.names=1)

# Le jeu de données contient les températures mensuelles moyennes de différentes villes. 
# Les moyennes et amplitudes annuelles sont indiquées en plus, ainsi que les coordonnées géographiques (latitude, longitude). 
# Une variable qualitative indique l’aire géographique (nord, sud, est, ouest). 
# L’objectif ici est de dresser une typologie des villes en utilisant seulement les températures mensuelles et de valider l’analyse 
# ensuite avec les variables supplémentaires. Les commandes suivantes permettent d’inspecter les caractéristiques principales du jeu de données.

class(temperature)
names(temperature)
rownames(temperature)
dim(temperature)
plot(as.numeric(temperature[1,1:12]), ylim= range(temperature[,1:12]))
lines(as.numeric(temperature[2,1:12]))
lines(as.numeric(temperature[3,1:12]), col="red")
lines(as.numeric(temperature[4,1:12]), col="blue")

# La commande suivante effectue l’ACP du jeu de données
res <- PCA(temperature,ind.sup=24:35,quanti.sup=13:16,quali.sup=17)

graphics.off() 
names(res)
# Pour accéder aux éléments de la liste
res$call

# Tracer le nuage des individus
plot.PCA(res,choix="ind")
plot.PCA(res,choix="ind",habillage=17)

# Q1 : Comment interpréter les deux premiers axes au vu de ces résultats ? Autrement dit qu’est-ce qui oppose les individus aux extrémités de chacun des axes ?
# Les observations sont opposées au sens des dimensions de la PCA. 

dimdesc(res)
# Q2 : Quelles sont les variables les plus corrélées à la composante 1 ? à la composante 2 ?

# Les colonnes les plus reliées à la première dimension sont : Annual, October, September, April ... 
# Quasiement toutes les colonnes sont reliées à la première dimension. 
# Une valeur élevée sur la première dimension est synonyme d'une valeur élevée sur Annual, October... et d'une latitude faible.

# Les colonnes les plus reliées à la deuxième dimension sont : Amplitude, Longitude, June, July..
# Une valeur élevée sur la première dimension est synonyme d'une valeur élevée sur Amplitude, Longitude... et d'une valeur faible sur February, December, January.

# Q3 : Quelle est la part de variance expliquée par les 2 premières composantes ? est-il utile de considérer les composantes suivantes pour ce jeu de données ?
res$eig

# Dans les 2 premières composantes, on comprend 98.29% de la variance.
plot.PCA(res, choix = c("ind"), invisible=c("ind.sup", "quali", "quanti.sup"))

# Q4 : Donnez deux capitales représentatives de l’axe 1, à l’opposé sur l’axe. Considérer les contributions (ou les cos2) et repérer deux villes ayant des coordonnées de signes opposés.
# Deux villes opposées sont Reykjavic et Athènes.
# Contributions aux axes : Athènes : 25.25, Reykjavic : 9.67
res$ind$contrib

# Q5 : Procédez de même avec les individus supplémentaires (qui ont le rôle de données de validation), c.a.d. les villes n’étant pas des capitales.
res$ind.sup$cos2
# Les contributions sont bien moindres.

plot.PCA(res, choix = c("ind"), invisible = c("ind"))
res$ind.sup

# Pour tracer le cercle de corrélation :
plot.PCA(res, choix = "var")

# Q6 : Quels sont les mois contribuant le plus à l’inertie sur l’axe 1 ? sur l’axe 2 ?
res$var
# Les mois contribuant le plus à l'intertie sur l'axe 1 sont : Avril, Septembre, Novembre.
# Les mois contribuant le plus à l'intertie sur l'axe 2 sont : Janvier, Fevrier, Mai, Juin, Juillet, Décembre.

# Q7 : Les résultats pour les variables quantitatives additionnelles sont stockées dans res$quanti.sup 
# À quelle composante principale pouvez-vous rattacher prioritairement chacune des variables supplémentaires ?
res$quanti.sup
# Annual peut être rattachà à la dimension 1. Amplitude à la 2.

# Q8 : Concernant les variables qualitatives supplémentaires : chaque catégorie est identifiée au barycentre des individus qui la possèdent.
res$quali.sup
plot.PCA(res, choix = "ind", invisible = c("ind", "ind.sup"))

# À quelle composante la catégorie ’East’ est-elle le plus corrélée ? quel est le signe de cette corrélation ?
# East est le plus corrélé à la dimension 2. La corrélation est positive.

# Q9 : . En se basant uniquement sur les deux premières composantes de l’ACP, 
# peut-on deviner le signe de la corrélation entre ’amplitude’ et ’janvier’ ?

res$var$cor
res$quanti.sup$cor

# La correlation entre Janvier et Dim 1 est 0.84, et avec Dim2 : -0.53.
# La corrélation entre Amplitude et Dim1 est 0.99 et avec Dim2 : -0.07.
# On peut s'attendre à une corrélation positive.

# Q10 : Conclusion : dressez une typologie sommaire des températures en Europe


