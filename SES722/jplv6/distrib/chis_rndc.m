function rn=chis_rndc(nn,v)
% PURPOSE: generates random chi-squared deviates
%          mex interface to Ranlib c-function library
%---------------------------------------------------
% USAGE:   rchi = chis_rnd(n,v)
% where:   n = a scalar for the size of the vector to be generated
%          v = the degrees of freedom, must be > 0
% RETURNS: n-vector with mean=v, variance=2*v
% --------------------------------------------------
% NOTE:    rchi = 2.0*gamm_rndc(1.0, v/2.0)
% SEE ALSO: chis_d, chis_invc, chis_cdfc, chis_pdfc
% --------------------------------------------------
% Method:     rchi = 2.0*sgamma(df/2.0), where sgamma() is the
%                    standardized gamma distribution
% --------------------------------------------------

% compile with:
% mex chis_rndc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com
