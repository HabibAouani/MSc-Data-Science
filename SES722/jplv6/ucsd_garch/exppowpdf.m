function prob = exppowpdf(x,nu)
% PURPOSE:  Evaluates the Probabiliy a vector of observations x(Nx1)
% has if drawn from a Exponential Power Dist'n with parameter nu
% USAGE prob = exppowpdf(x,nu) , will accept equal length vector arguments
%
%
% f(x)=Kd * exp (-|x|^nu)/((gamma(3/nu)/gamma(1/nu))^0.5)
% KD = inv(2 * gamma (1+(1/nu) ) )
%
% Taken from Tadikamalla 1980
%
% Written by: Kevin Sheppard      21-November-2000
% Included in the ucsd_garch toolbox and the JPL library
% Requires the JPL toolbox
%



Kd=inv(2*gamma(1+(1/nu)))
prob = Kd*exp(-(abs(x).^nu));
