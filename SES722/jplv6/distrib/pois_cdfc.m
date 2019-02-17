function f = pois_cdfc(x,lambda)
% PURPOSE: computes the cdf at x of the Poisson distribution
%          cmex interface to Ranlib c-library
%---------------------------------------------------
% USAGE:     cdf = pois_cdfc(x,lambda)
% where:     x   = variable vector (nx1)
%         lambda = mean 
%---------------------------------------------------
% RETURNS:  the  probability  of  x(i) or fewer events in  
%           a Poisson distribution with mean lambda
%---------------------------------------------------
% Method: Uses formula  26.4.21 of Abramowitz and Stegun,  
% Handbook of Mathematical Functions to reduce the 
% cumulative Poisson to the cumulative chi-square distribution.
%---------------------------------------------------
% SEE ALSO: pois_rndc, pois_invc, pois_pdfc 
%---------------------------------------------------

% compile with:
% mex pois_cdfc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com
