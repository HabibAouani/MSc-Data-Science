function prob = gedpdf(x,nu)
% PURPOSE: Evaluates the Probabiliy a vector of observations x(Nx1)
% has if drawn from a Generalzed Error Dist'n  with parameter nu
% which is the exponential power distn with variance normalized to 1
%
% USAGE prob = gedpdf(x,nu) , will accept equal length vector arguments
% 
% f(x)=Kd * exp (-|x|^nu)
% KD = inv(2 * gamma (1+(1/nu) ) )
%
% Taken from Tadikamalla 1980
%
% Written by: Kevin Sheppard      21-November-2000
% Included in the ucsd_garch toolbox and the JPL library
% Requires the JPL toolbox
%


beta=((2^(-2/nu))*(gamma(1/nu))/(gamma(3/nu)))^(0.5);
y=nu*exp(-0.5*(abs(x/beta).^(nu)))/(beta*gamma(1/nu)*(2^(1+1/nu)));
prob=y;
