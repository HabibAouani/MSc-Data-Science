% Load data
hprice1 = load('hprice1.raw')
y = hprice1(:,1);
[n,k] = size(hprice1);

X = [ones(n,1), hprice1(:,[3,4,5])]
beta = inv(X'*X)*X'*y

u = y - X * beta;

% Test the homoskedasticity
u2 = u.^2;
y = u2;

%% Unrestricted model
beta = inv(X' * X) * X' * y
u = y - X*beta
SSR0 = u' * u

%% Restricted model
X = [ones(n,1)];
beta = inv(X'*X)*X'*y
u = y-X*beta
SSR1 = u' * u

F = (SSR1-SSR0)/SSR0 * (n-4)/3

% K = 4 paramètres testés, q = 3 restrictions
% La F-Stat est grande et la p-value est petite.
% On rejette H0, il n'y a pas homoscédasticité

% --------------------

% Test the logarithmic form to control for heteroscedasticity
y = log(hprice1(:,1));
[n,k] = size(hprice1);

X = [ones(n,1), hprice1(:,[3,4,5])]
beta = inv(X'*X)*X'*y

u = y - X * beta;

% Test the homoskedasticity
u2 = u.^2;
y = u2;

%% Unrestricted model
beta = inv(X' * X) * X' * y
u = y - X*beta
SSR0 = u' * u

%% Restricted model
X = [ones(n,1)];
beta = inv(X'*X)*X'*y
u = y-X*beta
SSR1 = u' * u

F = (SSR1-SSR0)/SSR0 * (n-4)/3

%% Weighted Least Squares
y = hprice1(:, 1);
X = [ones(n, 1), hprice1(:, [3, 4, 5])]; 
lotsize = hprice1(:, 4)
y = y./sqrt(lotsize)

for i = 1:k
    X(:,i) = X(:,i)./sqrt(lotsize)
end

[n,k] = size(X)
beta=inv(X'*X)*X'*y
u = y - X * beta;

u2 = u.^2;
y = u2;

%% Unrestricted model
beta = inv(X' * X) * X' * y
u = y - X*beta
SSR0 = u' * u

%% Restricted model
X = [ones(n,1)];
beta = inv(X'*X)*X'*y
u = y-X*beta
SSR1 = u' * u
