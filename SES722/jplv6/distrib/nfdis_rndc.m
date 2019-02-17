function rnd = nfdis_rndc(n, v, c)
% PURPOSE: random deviates from the non-central F distribution
%          a cmex interface to Ranlib c-library
%--------------------------------------------------------------
% USAGE: rnd = nfdis_rndc(n,v,c)
% where:   n = length of vector to generate
%          a = numerator dof parameter, a scalar > 0
%          b = denominator dof parameter, a scalar > 0
%          c = non-centrality parameter, a scalar > 0
%--------------------------------------------------------------
% RETURNS: rnd = n x 1 vector of random deviates
%--------------------------------------------------------------
% METHOD:      Directly generates ratio of noncentral numerator chi-squared variate
%              to central denominator chi-squared variate.
%-------------------------------------------------------------- 
% SEE ALSO: nchi_d, nchi_pdfc, nchi_invc, nchi_cdfc
%--------------------------------------------------------------
  
% compile with:
% mex nchi_rndc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com

 