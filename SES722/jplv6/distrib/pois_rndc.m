function y = pois_rnd(n,lambda)
% PURPOSE: generate random draws from the possion distribution
%          a mex interface to Ranlib c-library
%--------------------------------------------------
% USAGE:  y = pois_rnd(n,lambda)
% where:   lambda = mean > 0 used for the draws
%               n = # of draws
%--------------------------------------------------  
% RETURNS: y = a vector of draws
%--------------------------------------------------  
% NOTES:  Ahrens, J.H. and Dieter, U.
%         Computer Generation of Poisson Deviates
%         From Modified Normal Distributions.
%         ACM Trans. Math. Software, 8, 2 (June 1982),163-179
%--------------------------------------------------
                    
% compile with:
% mex pois_rndc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com
