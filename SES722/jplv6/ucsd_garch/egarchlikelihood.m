function [LLF, h, likelihoods]= egarchlikelihood(parameters,data,p,q,errortype);
% PURPOSE: EGARCHLIKELIHOOD(P,Q) likelihood function.  Helper function to EGARCH
%
% [LLF, h, likelihoods]= egarchlikelihood(parameters,data,p,q,errortype);
%
% Inputs:
%   parameters:A vector of parameters,1+2p+q, for the terms in the EGARCH model below
%
%   P: Non-negative, scalar integer representing a model order of the ARCH 
%      process
%
%   Q: Positive, scalar integer representing a model order of the GARCH 
%      process: Q is the number of lags of the lagged conditional variances included
%      Can be empty([]) for ARCH process
%
%   errortyoe:  A number,
%           1 for - Gaussian Innovations
%           2 for - T-distributed errors
%           3 for - General Error Distribution
%
%
%
% Outputs:
%   LLF = the loglikelihood evaluated at the parameters
%
%   h = the estimated time varying VARIANCES
%
%   likelihoods = A T by 1+2p+q matrix of likelihoods for m testing and robuse SE estimation
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   EGARCH(P,Q) the following(wrong) constratins are used(they are right for the (1,1) case or any Arch case
%     (1) nu>2 of Students T and nu>1 for GED
%
%   The time-conditional variance, H(t), of a EGARCH(P,Q) process is modeled 
%   as follows:
%
%     log H(t) = Omega + Alpha(1)*r_{t-1}/(sqrt(h(t-1))) + Alpha(2)*r_{t-2}^2/(sqrt(h(t-2))) +...
%                    + Alpha(P)*r_{t-p}^2/(sqrt(h(t-p)))+ Absolute Alpha(1)* abs(r_{t-1}^2/(sqrt(h(t-1)))) + ...
%                    + Absolute Alpha(P)* abs(r_{t-p}^2/(sqrt(h(t-p)))) +  Beta(1)* log(H(t-1))
%                    + Beta(2)*log(H(t-2))+...+ Beta(Q)*log(H(t-q))
%
%
% Author: Kevin Sheppard
% kksheppard@ucsd.edu
% Revision: 1    Date: 10/15/2000

[r,c]=size(parameters);
if c>r
    parameters=parameters';
end


constp=parameters(1);
archp=parameters(2:p+1);
asparameters=parameters(p+2:2*p+1);
garchp=parameters(2*p+2:2*p+q+1);

if errortype ~=1;
    nu = parameters(2*p+q+2);
    parameters = parameters(1:2*p+q+1);
end



if isempty(q) | q==0
    m=p;
else
    m  =  max(p,q);
end

Tau=size(data,1);
stdEstimate =  std(data,1);                      
data        =  [stdEstimate(ones(m,1)) ; data];  
absdata = abs(data);
T           =  size(data,1);                    


h  =  data(1);
h  =  [h(ones(m,1)) ; zeros(T-m,1)];   % Pre-allocate the h(t) vector.


for t = (m + 1):T
    h(t) = exp(parameters' * [1 ; data(t-(1:p))./h(t-(1:p)); absdata(t-(1:p))./h(t-(1:p)); log(h(t-(1:q)))]);
end


Tau = T-m;
LLF = 0;
t = (m + 1):T;
if errortype == 1
    LLF  =  sum(log(h(t))) + sum((data(t).^2)./h(t));
    LLF  =  0.5 * (LLF  +  (T - m)*log(2*pi));
elseif errortype == 2
    LLF = Tau*gammaln(0.5*(nu+1)) - Tau*gammaln(nu/2) - Tau/2*log(pi*(nu-2));
    LLF = LLF - 0.5*sum(log(h(t))) - ((nu+1)/2)*sum(log(1 + (data(t).^2)./(h(t)*(nu-2)) ));
    LLF = -LLF;
else
    Beta = (2^(-2/nu) * gamma(1/nu)/gamma(3/nu))^(0.5);
    LLF = (Tau * log(nu)) - (Tau*log(Beta)) - (Tau*gammaln(1/nu)) - Tau*(1+1/nu)*log(2);
    LLF = LLF - 0.5 * sum(log(h(t))) - 0.5 * sum((abs(data(t)./(sqrt(h(t))*Beta))).^nu);
    LLF = -LLF;
end


if nargout > 2
    likelihoods=zeros(size(T));
    if errortype == 1
        likelihoods = 0.5 * ((log(h(t))) + ((data(t).^2)./h(t)) + log(2*pi));
        likelihoods = -likelihoods;
    elseif errortype == 2
        likelihoods = gammaln(0.5*(nu+1)) - gammaln(nu/2) - 1/2*log(pi*(nu-2))...
            - 0.5*(log(h(t))) - ((nu+1)/2)*(log(1 + (data(t).^2)./(h(t)*(nu-2)) ));
        likelihoods = -likelihoods;
    else
        Beta = (2^(-2/nu) * gamma(1/nu)/gamma(3/nu))^(0.5);
        likelihoods = (log(nu)/(Beta*(2^(1+1/nu))*gamma(1/nu))) - 0.5 * (log(h(t))) ...
            - 0.5 * ((abs(data(t)./(sqrt(h(t))*Beta))).^nu);
        likelihoods = -likelihoods;
    end
end

h=h(t);

if isnan(LLF)
    LLF=10e+5;
end

