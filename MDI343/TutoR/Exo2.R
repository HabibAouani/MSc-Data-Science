#' ---
#' title: " Le titre de mon projet"
#' output: html_document
#' author: jean Dupont
#' header-includes:\usepackage{bbm}
#' ---

# 1

m = morley
plot(m[c(1,3)])
v = matrix(m[,3], ncol=5)
boxplot(v,xlab="Experience",ylab="Resultat")

# 2
t <- read.csv("/Users/maelfabien/TelecomParisTech/MDI343/TutoR/tutoriel_R/temperatureTuto.csv")

plot(t[c(1,2)],type="l",main="Evolution de la temperature de la planete",ylab="Ecart (Celcius)")

# 3

plot(t[c(1,3)],type="l",main="Evolution de la temperature de la planete",ylab="Ecart (Celcius)",col="blue")
lines(t[c(1,4)],type="l",col="red")
legend("topleft",legend = c("Hemisphere Nord", "Hemisphere Sud"),lty=1,col=c("blue","red"))
$$\cos (\theta)$$
  
# 4
p1=subset(t,Year<=1950)
p1=data.matrix(p1)
hist(p1[,2],xlab="Ecart (C??)",probability=TRUE,main="Distribution",xlim=range(-1:1),ylim=range(0:5),col="blue")
p2=subset(t,Year>1950&Year<=1980)
p2=data.matrix(p2)
hist(p2[,2],add=TRUE,probability=TRUE,col="green")
p3=subset(t,Year>1980)
p3=data.matrix(p3)
hist(p3[,2],add=TRUE,probability=TRUE,col="red")
legend("topleft",legend = c("1880-1950","1951-1980","1981-2015"),lty=1,lwd=10,col=c("blue","green","red"))
  
  
   