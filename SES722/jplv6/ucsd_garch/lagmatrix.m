function [Y, X] = lagmatrix(y,p,c)
% PURPOSE: Construct an X matrix and a Y vector for use in an AR regression
% USAGE: [Y,X] = lagmatrix(y,p,c)
% y is the dependant variable(nx1)
% p is the number of lags(scalar)
% c=1 if you want to include a constant
% Y will be (n-p)x1
% X will be (n-p)xp(or p+1 if c=1)
%
%
% Written by: Kevin Sheppard      21-November-2000
% Included in the ucsd_garch toolbox and the JPL library
% Requires the JPL toolbox
%

% check input
if nargin~=3, error('lagmatrix: wrong # of input arguments'); end;

n=length(y);

% initialize Y and X
Y=y(p+1:n);
X=zeros(n-p,p);

for i=1:p
   X(:,i)=y(p-i+1:n-i);
end;
if c==1
   X=[ones(length(Y),1) X];
end;
[Y,X];
