% PURPOSE: An example using bma_g(),
%                           prt(),
%                           plt(),
% Bayesian model averaging estimation
%---------------------------------------------------
% USAGE: bma_d
%---------------------------------------------------

% load the love.data
% 39 MBA students in a class at U of Chicago
% From George and McCullogh (1993 JASA)
% y = happiness (column 1), 
%               10 = happy, 1 = suicidal
% x1 = money    (column 2)
%      family income in thousands
% x2 = sex,     (column 3)
%      0,1 with 1=satisfactory
% x3 = love     (column 4)
%       1,2,3 with 3 = love, 1 = lonely
% x4 = work,    (column 4)
%            1 = seeking other work
%            5 = job enjoyable
load love.dat;
[nobs nvar] = size(love);
y = love(:,1); 
x = love(:,2:nvar);

ndraw = 5000;

result = bma_g(ndraw,y,x);

vnames = strvcat('happiness','money','sex','love','work');

prt(result,vnames);
