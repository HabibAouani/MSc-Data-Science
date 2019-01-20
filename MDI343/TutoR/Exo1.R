# I. Loi des grands nombres

# 1
a = 0
b = 2
n = 100
X = runif(n,a,b)

# 2
S = cumsum(X) / (1:n)
mu = 0.5 * (a+b)

plot(S, type="l", xlab="k", ylab="Moy. Emp.", ylim=c(a,b))
abline(mu, 0, col="red")

# 3
X = runif(n,a,b)
S = cumsum(X) / (1:n)
lines(S, type="l", xlab="k", ylab="Moy. Emp.", ylim=c(a,b), col="blue")

# 4
rate = 0.05
n = 100
X = rexp(n, rate)

S = cumsum(X) / (1:n)
mu = 1/rate

plot(S, type="l", xlab="k", ylab="Moy. Emp.", ylim=c(0,50))
abline(mu, 0, col="red")

X = rexp(n, rate)

S = cumsum(X) / (1:n)
lines(S, type="l", xlab="k", ylab="Moy. Emp.", ylim=c(0,50), col="blue")

# II. Th??or??me central limite

# 1
m = 1000
n = 100
a = 0 
b = 2
mu=.5*(a+b)

Z=0

for (j in 1:m) {
  X = runif(n,a,b)
  Z[j] = sum(X)/n
}
hist(Z,probability=TRUE,breaks=50,main="Distribution de la moyenne empirique",xlab="Valeur",ylab="Densit??")

# 2
var = (b-a)^2/12
NX = seq(min(Z), max(Z), length.out=500)
NY = dnorm(NX, mean = mu, sd=sqrt(var/n)) 
lines(x=NX,y=NY,col="red")

# 3
m = 1000
n = 100
a = 0 
b = 2
rate = 0.05
mu=1/rate

Z=0

for (j in 1:m) {
  X = rexp(n,rate)
  Z[j] = sum(X)/n
}
hist(Z,probability=TRUE,breaks=50,main="Distribution de la moyenne empirique",xlab="Valeur",ylab="Densit??")

var = (1/rate)^2
NX = seq(min(Z), max(Z), length.out=500)
NY = dnorm(NX, mean = mu, sd=sqrt(var/n)) 
lines(x=NX,y=NY,col="red")

