% PURPOSE: An example using bma_g(),
%                           prt(),
%                           plt(),
% Bayesian model averaging estimation
%---------------------------------------------------
% USAGE: bma_d
%---------------------------------------------------

% generate a model
nobs = 200;
vin = [1 2];  % variables in the model
vout = [3 4]; % variables not in the model
nv1 = length(vin);
nv2 = length(vout);
nvar = nv1+nv2; % total # of variables
x1 = randn(nobs,nvar);
xdum1 = zeros(nobs,1);
xdum1(150:nobs,1) = 1.0;
xdum2 = zeros(nobs,1);
xdum2(125:150,1) = 1.0;
x2 = [xdum1 xdum2];

x1t = x1(:,vin); % true model based on variables in the model
x2t = x2(:,1:2);
xtrue = [x1t x2t];
[junk nvart] = size(xtrue);
btrue = ones(nvart,1);
btrue(3,1) = 5.0;

y = 10*ones(nobs,1) + xtrue*btrue + 0.5*randn(nobs,1);

ndraw = 5000;

result = bma_g(ndraw,y,x1,x2);

prt(result);
