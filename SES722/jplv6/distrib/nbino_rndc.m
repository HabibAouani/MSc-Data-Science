function rnd = nbino_rndc (n, ntrials, prob)
% PURPOSE: random sampling from a negative binomial distribution
%          cmex interface to Ranlib c-library
%---------------------------------------------------
% USAGE: rnd = nbino_rnd(n,ntrials,prob)
% where:       n = size of the vector of draws
%        ntrials = # of trials, a scalar
%           prob = probability of success, a scalar
%---------------------------------------------------
% RETURNS:
%        rnd = n x 1 vector of random deviates representing
%              the number of events from ntrials, 
%              each of which has a probability of success prob.
% --------------------------------------------------
% METHOD:  Algorithm from page 480 of Devroye, Luc
%          Non-Uniform Random Variate Generation.  Springer-Verlag,
%          New York, 1986.
% SEE ALSO: nbino_d, nbino_pdfc, nbino_cdfc, nbino_invc
%---------------------------------------------------

% compile with:
% mex nbino_rndc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com
