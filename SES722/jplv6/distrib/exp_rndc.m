function exp_rndc(n,m)
% PURPOSE: random draws from the exp(mean) distribution
%          mex interface to Ranlib c-function library
%--------------------------------------------------------------
% USAGE: rnd = exp_rndc(n,m)
% where:   n = size of the vector of draws
%          m = mean of distribution from which we generate draws
%              (m > 0)
%--------------------------------------------------------------
% RETURNS: n-vector of random draws from the exp(m) distribution
%--------------------------------------------------------------
% SEE ALSO: exp_d, exp_pdf, exp_inv exp_cdf
%--------------------------------------------------------------
% Method: 
%  Ahrens, J.H. and Dieter, U.
%  Computer Methods for Sampling From the
%  Exponential and Normal Distributions.
%  Comm. ACM, 15,10 (Oct. 1972), 873 - 882.
% rnd = sexp()*m, where sexp() is the standardized exponential distribution
%--------------------------------------------------------------

% compile with:
% mex exp_rndc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com

                              Function
     Generates a single random deviate from an exponential
     distribution with mean AV.
                              Arguments
     av --> The mean of the exponential distribution from which
            a random deviate is to be generated.
        JJV (av >= 0)
                              Method
     Renames SEXPO from TOMS as slightly modified by BWB to use RANF
     instead of SUNIF.
     For details see:
               Ahrens, J.H. and Dieter, U.
               Computer Methods for Sampling From the
               Exponential and Normal Distributions.
               Comm. ACM, 15,10 (Oct. 1972), 873 - 882.
