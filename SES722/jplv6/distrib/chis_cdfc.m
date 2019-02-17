function cdf = chis_cdfc(x, v)
% PURPOSE: cdf of the chi-squared distribution
%          a cmex interface to Ranlib c-library
%--------------------------------------------------------------
% USAGE: cdf = chis_cdf(x,v)
% where:   x = prob[chis(v) <= x], x = vector
%          v = chi-squared distribution dof parameter, a scalar 
%--------------------------------------------------------------
% RETURNS: cdf at each element of x of the beta distribution
%--------------------------------------------------------------
% NOTES:  Calls incomplete gamma function 
%          a = df/2, x = x/2
%          gamm_cdfc(x,a);
%-------------------------------------------------------------- 
% SEE ALSO: chis_d, chis_pdfc, chis_invc, chis_rndc
%--------------------------------------------------------------
  
% compile with:
% mex chis_cdfc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com
