function gb = gamm_rndc(n,a,r)
% PURPOSE: a vector of random draws from the gamma distribution
%          a cmex interface to the Ranlib c-library
%---------------------------------------------------
% USAGE: rnd = gamm_rndc(n,a,r)
% where: n = the size of the vector drawn 
%        a = parameter such that the mean of the gamma = a/r
%        r = parameter such that the variance of the gamma = a/(r^2)
%        note: a=c/2, c=2 equals chisq c random deviate 
%---------------------------------------------------
% RETURNS:
%        rnd = an n x 1 vector of random numbers from the gamma distribution      
% --------------------------------------------------
% NOTE:    rchi(v) = 2*gamm_rndc(n, 1, v/2)
%---------------------------------------------------
% SEE ALSO: gamm_invc, gamm_pdfc, gamm_cdfc
%---------------------------------------------------
