% Load data
load CRIME1.raw
% Histogram
hist(CRIME1(:,9))
hist(CRIME1(:,1))
% Descriptive statistics
mean(CRIME1)'
mean(CRIME1(:,1:13))'
std(CRIME1(:,1:13))'
min(CRIME1)'
max(CRIME1)'
cov(CRIME1)'
corrcoef(CRIME1(:,1:13))'
% Load Wage data
load WAGE1.raw
% Average wage for each sex
s=(WAGE1(:,6)==1);
sum(s)
wage1f=WAGE1(s,:)
mean(WAGE1(s,1:21))'
% Wage discrimination
y=WAGE1(:,1)
[n,k]=size(WAGE1) 
X=[ones(n,1),WAGE1(:,[2,3,4])]
[n,k]=size(X)
% Residuals
beta=inv(X'*X)*X'*y
u=y-X*beta

sig2=u'*u/(n-4)
std=sqrt(diag(sig2*inv(X'*X)))

hist(u)
% Log of salary
X=([ones(n,1),log(WAGE1(:,[2,3,4]))])
X(isinf(X)|isnan(X)) = 0;
beta=inv(X'*X)*X'*y
u=y-X*beta
hist(u)

% Remove outliers
indices = find(u>2.5);
u(indices) = [];
hist(u)