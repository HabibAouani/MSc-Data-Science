import qstat2.*

% Load data
phillips = load('phillips.raw')

y = phillips(:,3);
plot(y)

[qstat,pval] = qstat2(y,1)

y_ = y(2:n)
y_lag = y(1 : n-1)
X = y_lag

[n,k] = size(X)
beta=inv(X'*X)*X'*y_



