function results = lmtest1(data,q)
% PURPOSE: Performs an LM test for the presense of autocorrelation in q lags
% Under the null of no serial correlation, this is asymptotically 
% distributed X2(q)
%
% USAGE : [results] = lmtest2(data,q)
%
% INPUTS:
% data -     A set of deviates from a process with or without mean 
% q-         The maximum number of lags to regress on.  The statistic and pval will be returned for all sets of 
%            lagged squarrd residuals up to and including q
%
% OUTPUTS:
% results, a structure with fields:
%
% statistic - A Qx1 vector of statistics
% pval      - A Qx1 set of appropriate pvals
%
%
% Written by: Kevin Sheppard      27-March-2001
% Included in the ucsd_garch toolbox and the JPL library
% Requires the JPL toolbox
%


statistic=zeros(q,1);
pval=zeros(q,1);

for i=1:q
   [y,x]=lagmatrix(data,i,1);
   beta = x\y;
   rsquared=1-((y-x*beta)'*(y-x*beta)/((y-mean(y))'*(y-mean(y))));
   statistic(i)=length(y)*rsquared;
end
results.statistic=statistic;
results.pval=1-chis_cdf(statistic,(1:q)');

