function rnd = beta_rndc(n, a, b)
% PURPOSE: random draws from the beta(a,b) distribution
%          mex interface to Ranlib c-function library
%--------------------------------------------------------------
% USAGE: rnd = beta_rnd(n,a,b)
% where:   n = size of the vector of draws
%          a = beta distribution parameter, a = scalar 
%          b = beta distribution parameter  b = scalar 
% NOTE: mean = a/(a+b), variance = ab/((a+b)*(a+b)*(a+b+1))
% The density of the beta is:
%       x^(a-1) * (1-x)^(b-1) / B(a,b) for 0 < x < 1
%--------------------------------------------------------------
% RETURNS: n-vector of random draws from the beta(a,b) distribution
%--------------------------------------------------------------
% SEE ALSO: beta_d, beta_pdf, beta_inv, beta_rnd
%--------------------------------------------------------------
% Method
%     R. C. H. Cheng
%     Generating Beta Variate with Nonintegral Shape Parameters
%     Communications of the ACM, 21:317-322  (1978)
%     (Algorithms BB and BC)
%--------------------------------------------------------------

% compile with:
% mex beta_rndc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com
