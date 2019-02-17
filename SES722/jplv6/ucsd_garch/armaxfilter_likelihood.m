function [LLF, errors, likelihoods] = armaxfilter_likelihood(parameters , regressand , regressors, ar , ma)
% PURPOSE: [LLF] = armaxfilter_likelihood(parameters , regressand , regressors, ar , ma)
% 
% Inputs:
%
% parameters:   A vector of GARCH process aprams of the form [constant, arch, garch]
% regressand:   A set of zero mean residuals
% regressors:   A matrix of exogenous(conditionally) of size (1+nlags+numX) by t with a ci
% ar:           The AR order
% ma:           The MA order of the ARMA process
%
% Outputs
% LLF:          Minus 1 times the log likelihood
%
% This is a helper function for armaxfilter
%
%
% Author: Kevin Sheppard
% kksheppard@ucsd.edu
% Revision: 1.00    Date: 3/28/2001

tau=length(regressand);
T=tau+ma;
e=zeros(T,1);
regressand=[zeros(ma,1);regressand];
regressors=[zeros(ma,size(regressors,2));regressors];

e=armaxcore(e,regressors*parameters(1:size(regressors,2)),regressand,parameters,size(regressors,2),ma,T);
%for t = (ma + 1):T
% e(t)=regressand(t)-parameters'*[regressors(t,:)';e((t-ma):(t-1))];
%end


t    = (ma + 1):T;
E=e(t)'*e(t);
sigma2=(E)/(tau-length(parameters));

LLF  =  tau*(log(sigma2)) + (E/sigma2);
LLF  =  0.5 * (LLF  +  (tau)*log(2*pi));

if nargout>1
    errors=e(t);
    likelihoods  =  (log(sigma2)) + ((errors.^2)./sigma2);
    likelihoods  =  -0.5 * (likelihoods  +  log(2*pi));
end
