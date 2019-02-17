function cdf = nbino_cdfc (x, n, p)
% PURPOSE: cdf at x of the negative binomial(n,p) distribution
%          a mex interface to Randlib c-library
%---------------------------------------------------
% USAGE: cdf = nbino_cdfc(x,n,p)
% where: p = the probability of success (0 < p < 1)
%        n = number of trials  ( n > 0 )
%        x = vector to be evaluated
%---------------------------------------------------
% RETURNS:  the probability that it there will be x(i)
%           or fewer failures before there are n successes, 
%           with each binomial trial having a probability of success p.
%     Prob(# failures = x(i) | n successes, p)  =
%                        ( n + x(i) - 1 )
%                        (              ) * p^n * (1-p)^x(i)
%                        (      x(i)    )
% --------------------------------------------------
% METHOD: Formula 26.5.26 of Abramowitz and Stegun, Handbook of
%     Mathematical Functions (1966) is used to reduce the negative
%     binomial distribution to the cumulative beta distribution.
% --------------------------------------------------
% SEE ALSO: nbino_d, nbino_pdfc, nbino_rndc, nbino_invc
%---------------------------------------------------

% compile with:
%  mex nbino_cdfc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com

