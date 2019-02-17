function h=garchcore(h,data,parameters,p,q,m,T)
% PURPOSE: Helper function part of UCSD_GARCH toolbox. Used if you do not use the MEX file.
%
% Author: Kevin Sheppard
% kksheppard@ucsd.edu
% Revision: 1    Date: 3/28/2001


for t = (m + 1):T
   h(t) = parameters' * [1 ; data(t-(1:p)).^2;  h(t-(1:q)) ];
end