function x = fdis_rndc(n,a,b)
% PURPOSE: returns random draws from the F(a,b) distribution
%          mex interface to Randlib c-library
%---------------------------------------------------
% USAGE: rnd = fdis_rnd(n,a,b)
% where: n = size of vector 
%        a = scalar dof parameter
%        b = scalar dof parameter
%---------------------------------------------------
% RETURNS:
%        a vector of random draws from the F(a,b) distribution      
% --------------------------------------------------
% NOTES:
% mean should equal (b/a)*((a/2)/(b/2-1))
% METHOD:  Directly generates ratio of chi-squared variates
% --------------------------------------------------
% SEE ALSO: fdis_d, fdis_cdfc, fdis_invc, fdis_pdfc, fdis_prb
%---------------------------------------------------

% compile with:
% mex fdis_rndc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com
