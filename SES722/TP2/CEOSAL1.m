wage1=load('WAGE1.raw')
[n,k]=size(wage1)

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

% model non restreint

