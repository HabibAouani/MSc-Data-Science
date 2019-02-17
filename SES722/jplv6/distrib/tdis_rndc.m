function t = tdis_rnd (n,df)
% PURPOSE: returns random draws from the t(n) distribution
%          cmex interface to Ranlib c-library
%---------------------------------------------------
% USAGE: rnd = tdis_rnd(n,df)
% where: n = size of vector 
%        df = a scalar dof parameter
% NOTE:  mean=0, std=1
%---------------------------------------------------
% RETURNS:
%        a vector of random draws from the t(n) distribution      
% --------------------------------------------------
% SEE ALSO: tdis_cdf, tdis_rnd, tdis_pdf, tdis_prb
%---------------------------------------------------

% compile with:
% mex tdis_cdfc.c matrixjpl.c randomlib.c

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jpl@jpl.econ.utoledo.edu

  
