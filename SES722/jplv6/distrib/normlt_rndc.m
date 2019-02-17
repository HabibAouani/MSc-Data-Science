function result = normlt_rndc(mu,sigma2,left)
% PURPOSE: CMEX to compute random draws from a left-truncated normal
%          distribution, with mean = mu, variance = sigma2
% ------------------------------------------------------
% USAGE: y = normlt_rndc(mu,sigma2,left)
% where:   mu = mean (scalar or vector)
%      sigma2 = variance (scalar or vector)
%        left = left truncation point (scalar or vector)
% ------------------------------------------------------
% RETURNS: y = (scalar or vector) the size of mu, sigma2
% ------------------------------------------------------
% NOTES: This is merely a convenience function that
%        calls normt_rnd with the appropriate arguments
% ------------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jpl@jpl.econ.utoledo.edu

if nargin ~= 3
error('normlt_rnd: Wrong # of input arguments');
end;

n1 = length(mu);
n2 = length(sigma2);
n3 = length(left);

if (n1 == n2)& (n1 == n3)
  right = mu + 5*sqrt(sigma2);
  result = normal_trunc(mu,sigma2,left,right);
else
	n = max([n1 n2 n3]);
	iota = ones(n,1);
	if n1 == 1
		mu = mu*iota;
	end;
	if n2 == 1
		sigma2 = sigma2*iota;
	end;
	if n3 == 1
		left = left*iota;
	end;
	
  right = mu + 5*sqrt(sigma2);
  result = normal_trunc(mu,sigma2,left,right);
end;

		

