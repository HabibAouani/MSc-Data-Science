function cdf = gamm_cdfc(x, a)
% PURPOSE: returns the cdf at x of the gamma(a) distribution
%          a mex interface to Randlib c-library
%---------------------------------------------------
% USAGE: cdf = gamm_cdf(x,a)
% where: x = a vector 
%        a = a scalar parameter
%---------------------------------------------------
% RETURNS: a vector with the cumulative of the incomplete gamma
%          distribution, i.e., the integral from 0 to x(i) of
%          (1/GAM(A))*EXP(-T)*T**(A-1) DT
%          where GAM(A) is the complete gamma function of A, i.e.,
%          GAM(A) = integral from 0 to infinity of
%                    EXP(-T)*T**(A-1) DT
%---------------------------------------------------
% METHOD: EVALUATION OF THE INCOMPLETE GAMMA RATIO FUNCTIONS
% --------------------------------------------------
% SEE ALSO: gamm_d, gamm_pdfc, gamm_rndc, gamm_invc
%---------------------------------------------------

% compile with:
% mex gamm_cdfc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com
