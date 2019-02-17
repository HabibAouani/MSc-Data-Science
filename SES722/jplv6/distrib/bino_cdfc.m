function cdf = bino_cdfc (x, n, p)
% PURPOSE: cdf at x of the binomial(n,p) distribution
%          a mex interface to Randlib c-library
%---------------------------------------------------
% USAGE: cdf = bino_cdfc(x,n,p)
% where: p = the probability of success (0 < p < 1)
%        n = number of trials  ( n > 0 )
%        x = vector to be evaluated
% NOTE: mean [bino(n,p)] = n*p, variance = n*p(1-p)
%---------------------------------------------------
% RETURNS:   cdf = vector with the probability of 0  to  x(i)  
%            successes in  n binomial trials, each of which 
%            has a probability of success, p
% --------------------------------------------------
% METHOD:  Formula  26.5.24    of   Abramowitz  and    Stegun,  Handbook   of
%     Mathematical   Functions (1966) is   used  to reduce the  binomial
%     distribution  to  the  cumulative    beta distribution.
% --------------------------------------------------
% SEE ALSO: bino_d, bino_pdfc, bino_rndc, bino_invc
%---------------------------------------------------

% compile with:
%  mex bino_cdfc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com

