% PURPOSE: An example of using invpd()                               
%          a function to mimic Gauss invpd
%          replaces small eigenvalues with 0.01 values
%---------------------------------------------------
% USAGE: invpd_d
%---------------------------------------------------

% generate an ill-conditioned matrix
n = 100; k = 3;
x = randn(n,k);
x(:,2) = x(:,1) + (1e-8)*randn(n,1);
xpx = x'*x;


xinv = inv(xpx);
disp('inverse using MATLAB inv() of ill-conditioned matrix');
xinv
[xi flag] = invpd(xpx);
if flag == 1
disp('matrix is not positive definite');
disp('small eigenvalues augmented');
end;
disp('inverse using invpd() of ill-conditioned matrix');
xi
% show that this doesn't necessarily equal 
% the identity
format long;
disp('the invpd() result does not necessarily equal the Identity');
xi*xpx