function cdf = nfdis_cdfc(x,a,b,c)
% PURPOSE: cdf of the non-central F distribution
%          a cmex interface to Ranlib c-library
%--------------------------------------------------------------
% USAGE: cdf = nfdis_cdfc(x,a,b,c)
% where:   x = prob[nfdis(a,b,c) <= x], x = vector
%          a = numerator dof parameter, a scalar 
%          b = denominator dof parameter, a scalar 
%          c = non-centrality parameter, a scalar
%--------------------------------------------------------------
% RETURNS: cdf at each element of x of the F distribution
%--------------------------------------------------------------
% NOTES: a vector with the probability that a variable with
%        the non-central F distribution, with a,b dof and
%        non-centrality  parameter c is less than or equal to x(i).
%-------------------------------------------------------------- 
% METHOD:      USES FORMULA 26.6.20 OF REFERENCE FOR INFINITE SERIES.
%     SERIES IS CALCULATED BACKWARD AND FORWARD FROM J = LAMBDA/2
%     (THIS IS THE TERM WITH THE LARGEST POISSON WEIGHT) UNTIL
%     THE CONVERGENCE CRITERION IS MET.
%     FOR SPEED, THE INCOMPLETE BETA FUNCTIONS ARE EVALUATED
%     BY FORMULA 26.5.16.
%     HANDBOOD OF MATHEMATICAL FUNCTIONS
%     EDITED BY MILTON ABRAMOWITZ AND IRENE A. STEGUN
%     NATIONAL BUREAU OF STANDARDS APPLIED MATEMATICS SERIES - 55
%     MARCH 1965
%     P 947, EQUATIONS 26.6.17, 26.6.18
%-------------------------------------------------------------- 
% SEE ALSO: nfdis_d, nfdis_pdfc, nfdis_invc, nfdis_rndc
%--------------------------------------------------------------
  
% compile with:
% mex nfdis_cdfc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com

 