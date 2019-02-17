function rnd = nchi_rndc(n, v, c)
% PURPOSE: random deviates from the non-central chi-squared distribution
%          a cmex interface to Ranlib c-library
%--------------------------------------------------------------
% USAGE: rnd = nchi_rndc(n,v,c)
% where:   n = length of vector to generate
%          v = chi-squared distribution dof parameter, a scalar 
%          c = non-centrality parameter, a scalar
%--------------------------------------------------------------
% RETURNS: rnd = n x 1 vector of random deviates
%--------------------------------------------------------------
% METHOD:   Uses fact that noncentral chi-squared is the sum of a chi-squared
%    deviate with DF-1  degrees of freedom plus the square of a normal
%    deviate with mean XNONC and standard deviation 1. Directly 
%    generates ratio of noncentral numerator chi-squared variate
%    to central denominator chi-squared variate.
%-------------------------------------------------------------- 
% SEE ALSO: nchi_d, nchi_pdfc, nchi_invc, nchi_cdfc
%--------------------------------------------------------------
  
% compile with:
% mex nchi_rndc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com

 