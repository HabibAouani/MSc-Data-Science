% Load data
saving1 = load('saving.raw')
y = saving1(:,1);
inc = [ones(n,1),saving1(:,[2])]
[n,k] = size(saving1);

beta = inv(inc'*inc)*inc'*y
u = y - inc * beta;

% Ponderation des observations

ys = y./sqrt(inc)
Xs = [ones(n,1)./sqrt(inc) inc./sqrt(inc)];
beta = Xs(Xs'*Xs)*Xs'*ys
u = ys - Xs * beta;
sig2 = u'*u/(n-k)
std = sqrt(diag(sig2*inv(Xs'*Xs)))
t = beta./std

% Generalized Least Squares
P = diag(1./sqrt(inc))
OMEG = P'*P;
betaG = inv(X'*OMEG*X)*X'*OMEG*y

% Heteroscedasticite multiplicative
lu2 = log(u.^2)
y = lu2

beta = X(X'*X)*X'*y
