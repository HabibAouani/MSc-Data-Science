function cdf = nchi_cdfc(x, v, n)
% PURPOSE: cdf of the non-central chi-squared distribution
%          a cmex interface to Ranlib c-library
%--------------------------------------------------------------
% USAGE: cdf = nchi_cdfc(x,v,n)
% where:   x = prob[nchi(v,n) <= x], x = vector
%          v = chi-squared distribution dof parameter, a scalar 
%          n = non-centrality parameter, a scalar
%--------------------------------------------------------------
% RETURNS: cdf at each element of x of the beta distribution
%--------------------------------------------------------------
% NOTES: a vector with the probability that a variable with
%        the non-central chi-square distribution, with dof v, and
%        non-centrality  parameter n is less than or equal to x(i).
%-------------------------------------------------------------- 
% METHOD: Uses formula 26.4.25 of Abramowitz and Stegun, Handbook of
%         Mathematical Functions, US NBS (1966) to calculate the
%         non-central chi-square.
%-------------------------------------------------------------- 
% SEE ALSO: nchi_d, nchi_pdfc, nchi_invc, nchi_rndc
%--------------------------------------------------------------
  
% compile with:
% mex nchi_cdfc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com

 