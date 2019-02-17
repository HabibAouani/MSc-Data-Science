function result = normt_rndc(mu,sigma2,left,right)
% PURPOSE: CMEX random draws from a normal truncated to (left,right) interval
% ------------------------------------------------------
% USAGE: y = normt_rndc(mu,sigma2,left,right)
% where:   mu = mean (nobs x 1)
%      sigma2 = variance (nobs x 1)
%        left = left truncation points (nobs x 1)
%       right = right truncation points (nobs x 1)
% ------------------------------------------------------
% RETURNS: y = (nobs x 1) vector
% ------------------------------------------------------
% NOTES: use y = normt_rndc(mu,sigma2,left,mu+5*sigma2)
%        to produce a left-truncated draw
%        use y = normt_rnd(mu,sigma2,mu-5*sigma2,right)
%        to produce a right-truncated draw
% ------------------------------------------------------
% SEE ALSO: normlt_rndc (left truncated draws), normrt_rndc (right truncated)
%

% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jpl@jpl.econ.utoledo.edu



if nargin ~= 4
error('normt_rndc: wrong # of input arguments');
end;

n = length(mu);
if length(sigma2) ~= n
sigma2 = ones(n,1)*sigma2;
end;
if length(left) ~= n
left = ones(n,1)*left;
end;
if length(right) ~= n
right = ones(n,1)*right;
end;

result = normal_trunc(mu,sigma2,left,right);

