function cdf = exppowcdf(x,nu)
% PURPOSE: Evaluates the Probabiliy a vector of observations x(Nx1)
% has if drawn from a Exponential Power Dist'n with parameter nu
% USAGE prob = exppowpdf(x,nu) , will accept equal length vector arguments
% f(x)=Kd * exp (-|x|^nu)/((gamma(3/nu)/gamma(1/nu))^0.5)
% KD = inv(2 * gamma (1+(1/nu) ) )
%
% Taken from Tadikamalla 1980
%
% Written by: Kevin Sheppard      21-November-2000
% Included in the ucsd_garch toolbox and the JPL library
% Requires the JPL toolbox
%



over=x>0
under=x<0
same=x==0

cdf=zeros(size(x));
x(over)
cdf(over)=(1/2)-(gamma(1/nu)*(1-gammainc(x(over).^nu,1/nu)))/(2*nu*gamma(1+(1/nu)))+(1/2);
xunder=-x(under);
cdf(under)=1/2-((1/2)-(gamma(1/nu)*(1-gammainc(xunder.^nu,1/nu)))/(2*nu*gamma(1+(1/nu))));
cdf(same)=.5;


