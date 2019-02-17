function F = stdtdis_cdf (x, n)
% PURPOSE: returns cdf at x of the standardized to unit variance t(n) distribution
%---------------------------------------------------
% USAGE: cdf = stdtdis_cdf(x,n)
% where: x = a vector 
%        n = a scalar parameter with dof must be > 2
%---------------------------------------------------
% RETURNS:
%        a vector of cdf at each element of x of the standardized t(n) distribution      
% --------------------------------------------------
% SEE ALSO: stdtdis_rnd, stdtdis_pdf
%---------------------------------------------------
%
% Anders Holtsberg, 18-11-93
% Copyright (c) Anders Holtsberg
% modified by J.P. LeSage
% modified by Kevin Sheppard
% kksheppard@ucsd.edu

if nargin ~= 2
error('Wrong # of arguments to tdis_cdf');
end;

if any(any(n<=0))
   error('tdis_cdf dof is wrong');
end

x=x.*sqrt(n./(n-2));
[nobs junk] = size(x);
neg = x<0;
F = fdis_cdf(x.^2,1,n);
iota = ones(nobs,1);
out = iota-(iota-F)/2;
F = out + (iota-2*out).*neg;
    

