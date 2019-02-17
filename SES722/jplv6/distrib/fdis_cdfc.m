function cdf = fdis_cdfc(x,a,b)
% PURPOSE: returns cdf at x of the F(a,b) distribution
%          mex interface to Ranlib c-library
%---------------------------------------------------
% USAGE: cdf = fdis_cdfc(x,a,b)
% where: x = a vector 
%        a = numerator dof
%        b = denominator dof
%---------------------------------------------------
% RETURNS:  a vector with the integral from 0 to x(i) 
%           of the f-density with a-numerator, b-denominator
%           degrees of freedom.
%---------------------------------------------------
% METHOD: Formula 26.5.28 of Abramowitz and Stegun is used to reduce
%         the cumulative F to a cumulative beta distribution.
% --------------------------------------------------
% SEE ALSO: fdis_d, fdis_invc, fdis_rndc, fdis_pdfc, fdis_prb
%---------------------------------------------------

% compile with:
% mex fdis_cdfc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com
