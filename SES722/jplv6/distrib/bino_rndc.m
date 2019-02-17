function rnd = bino_rndc (n, ntrials, prob)
% PURPOSE: random sampling from a binomial distribution
%          cmex interface to Ranlib c-library
%---------------------------------------------------
% USAGE: rnd = bino_rnd(n,ntrials,prob)
% where:       n = size of the vector of draws
%        ntrials = # of trials, a scalar
%           prob = probability of success, a scalar
%---------------------------------------------------
% RETURNS:
%        rnd = n x 1 vector of random deviates representing
%              the number of events from ntrials, 
%              each of which has a probability of success prob.
% NOTE: mean = ntrials*prob, variance = ntrials*prob(1-prob)
% --------------------------------------------------
% METHOD: algorithm BTPE from:
%         Kachitvichyanukul, V. and Schmeiser, B. W.
%         Binomial Random Variate Generation.
%         Communications of the ACM, 31, 2 (February, 1988) 216.
% SEE ALSO: bino_d, bino_pdfc, bino_cdfc, bino_invc
%---------------------------------------------------

% compile with:
% mex beta_rndc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com

