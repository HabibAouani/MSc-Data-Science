function F = tdis_cdfc(x, n)
% PURPOSE: returns cdf at x of the t(n) distribution
%          mex interface to Ranlib c-library
%---------------------------------------------------
% USAGE: cdf = tdis_cdfc(x,n)
% where: x = a vector 
%        n = a scalar parameter with dof
%---------------------------------------------------
% RETURNS:
%        a vector of cdf at each element of x of the t(n) distribution      
% --------------------------------------------------
% METHOD:  Formula 26.5.27 of Abramowitz and Stegun, Handbook  of
%     Mathematical Functions is used to reduce the t-distribution
%     to an incomplete beta.
% --------------------------------------------------
% SEE ALSO: tdis_invc, tdis_rndc, tdis_pdfc, tdis_prb
%---------------------------------------------------

% compile with:
% mex tdis_cdfc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com
