function cdf = beta_cdfc(x, a, b)
% PURPOSE: cdf of the beta distribution
%          a cmex interface to Ranlib c-library
%--------------------------------------------------------------
% USAGE: cdf = beta_cdf(x,a,b)
% where:   x = prob[beta(a,b) <= x], x = vector
%          a = beta distribution parameter, a = scalar 
%          b = beta distribution parameter  b = scalar 
%--------------------------------------------------------------
% RETURNS: cdf at each element of x of the beta distribution
%--------------------------------------------------------------
% NOTES: Calculates the cdf to X of the incomplete beta distribution
%        with parameters a and b.  This is the integral from 0 to x
%        of (1/B(a,b))*f(t)) where f(t) = t**(a-1) * (1-t)**(b-1)
%-------------------------------------------------------------- 
% METHOD: Didonato, Armido R. and Morris, Alfred H. Jr. (1992) Algorithim
%         708 Significant Digit Computation of the Incomplete Beta Function
%         Ratios. ACM ToMS, Vol.18, No. 3, Sept. 1992, 360-373.
%-------------------------------------------------------------- 
% SEE ALSO: beta_d, beta_pdf, beta_inv, beta_rnd
%--------------------------------------------------------------
  
% compile with:
% mex beta_cdfc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com
