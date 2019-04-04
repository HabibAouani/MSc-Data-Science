wage1=load('WAGE1.raw')
[n,k]=size(wage1)

% Exploratory data analysis
hist(wage1(:,1)) %wage
hist(wage1(:,2)) %educ

mean(wage1(:,:))'
std(wage1(:,:))'
min(wage1)'
max(wage1)'
cov(wage1)'
corrcoef(wage1(:,:))'

% explain ceo salary by sales
y=wage1(:,1)
X=[ones(n,1),wage1(:,[2,3,4])]

% Compute beta and residual
beta=inv(X'*X)*X'*y
u=y-X*beta

sig2=u'*u/(n-4)
std=sqrt(diag(sig2*inv(X'*X)))

hist(u)

% Remove outliers
indices = find(u>2.5);
s = (u<=2.5)
u(indices) = [];

% test hypothesis
beta
std
t = beta./std

% seuil critique et p-values
C1 = tinv(0.95, n-4)
C2 = tinv(0.975, n-4)

% log wage
y=log(wage1(:,1))
beta=inv(X'*X)*X'*y
std=sqrt(diag(sig2*inv(X'*X)))
t = beta./std

% test beta educ = 0.1
t_educ = (beta(2)-0.1)/std(2)
% p_educ = tdis_prb(t, n-k)

% Rendement éducation = rendement expérience professionnelle
capitaltot = X(:,2) + X(:,3)
% remove colinearity
X=[X(:,[1,2,4]),capitaltot];
beta=inv(X'*X)*X'*y
std=sqrt(diag(sig2*inv(X'*X)))
t = beta(4)/std(4)

% model non contraint
X0=[ones(n,1),wage1(:,[2,3,4])]
y0=log(wage1(:,1))
beta0=inv(X0'*X0)*X0'*y0
u0=y0-X0*beta0
SSR0=u0'*u0

% model contraint
X1=[ones(n,1),wage1(:,[4])]
y1=log(wage1(:,1))
beta1=inv(X1'*X1)*X1'*y1
u1=y1-X1*beta1
SSR1=u1'*u1

% F-Stat : K = nb var modèle non contraint
K = 4
F = (SSR1-SSR0)/(SSR0) * (n-K)/2

% p-value
fdis_prb(F, 2, n-K)

% Interactions
X=wage1
educ=X(:,2)
exper=X(:,3)
tenure=X(:,4)
female=X(:,6)
married=X(:,7)
marrmale = (1-female).*married
marrfem = female.*married
singfem=female.*(1-married)

% Model non restreint
X = [ones(n,1) educ exper tenure marrmale marrfem singfem]
y=log(wage1(:,1))
beta=inv(X'*X)*X'*y
u=y-X*beta
SSR0 = u'*u

% Model restreint
X = [ones(n,1) educ exper tenure marrmale]
y=log(wage1(:,1))
beta=inv(X'*X)*X'*y
u=y-X*beta
SSR1 = u'*u

K = 6
F = (SSR1-SSR0)/(SSR0) * (n-K)/2

% Effet des femmes
% Non contraint
femeduc = female.*educ
X = [ones(n,1) educ exper tenure female femeduc]
y=log(wage1(:,1))
beta=inv(X'*X)*X'*y
u=y-X*beta
sig2=u'*u/(n-4)
std=sqrt(diag(sig2*inv(X'*X)))
t = beta./std

% Contraint
X = [ones(n,1) educ, exper, tenure]
y=log(wage1(:,1))
beta=inv(X'*X)*X'*y
u=y-X*beta
SSR1 = u'*u
