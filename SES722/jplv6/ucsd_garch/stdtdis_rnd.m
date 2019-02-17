function t = stdtdis_rnd (n,df)
% PURPOSE: returns random draws from the standardized t(n) distribution with unit variance
%---------------------------------------------------
% USAGE: rnd = stdtdis_rnd(n,df)
% where: n = size of vector 
%        df = a scalar dof parameter must be > 2
% NOTE:  mean=0, std=1
%---------------------------------------------------
% RETURNS:
%        a vector of random draws from the standardized t(n) distribution      
% --------------------------------------------------
% SEE ALSO: stdtdis_cdf, stdtdis_rnd, stdtdis_pdf, 
%---------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jpl@jpl.econ.utoledo.edu
% modified by Kevin Sheppard
% kksheppard@ucsd.edu
  
if nargin ~= 2
error('Wrong # of arguments to tdis_rnd');
end;

if is_scalar(df)
 if (df<=0)
   error('tdis_rnd dof is wrong');
 end
 z = randn(n,1);
 x = chis_rnd(n,df);
 t = (z*sqrt(df))./sqrt(x);
else
 error('tdis_rnd: df must be a scalar');
end;
t=t./(sqrt(df/(df-2)));