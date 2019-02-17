% PURPOSE: An example using bma_g(),
%                           prt(),
%                           plt(),
% Bayesian model averaging estimation
%---------------------------------------------------
% USAGE: bma_gd2
%---------------------------------------------------

% load Ehrlich crime data
load crime.dat;
nobs = length(crime);
y = log(crime(:,1));
x = crime(:,2:16);
% pull out dummies
x2 = x(:,2);
x1 = log([x(:,1) x(:,3:15)]);

vnames = strvcat('y','male14-24','school','police60','police59', ...
'labor','sex','pop','nonw','unemp Y','unemp O','wealth', ...
'inequal','impris','timeser','south');

ndraw = 1000;

result = bma_g(ndraw,y,x1,x2);

prt(result,vnames);
