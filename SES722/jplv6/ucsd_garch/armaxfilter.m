function [parameters, stderrors, robustSE, SEregression, errors, LLF, scores, likelihoods]=armaxfilter(y,constant,ar,ma,x,options)
% PURPOSE: Function designed to provide a good ARMAX time series filter
% USAGE:
% [parameters, stderrors, robustSE, SEregression, errors, LLF, scores, likelihoods]=armaxfilter(y,constant,ar,ma,x,options)
% 
% INPUTS:
%  y        - Dependant Time-Series vairable [T by 1]
%  constant - 1 or 0. 1 indicates the presece of a constant in the regression, 0 no constant
%  ar       - the AR order desired
%  ma       - the MA order desired
%  x        - [optional] a matrix of other exogenous variables.  These line up exactly with the Y's and if  
%             they are time seriesm you need to shift them down by 1 place,  i.e. pad the bottom with 1 
%             observation and cut off the top row [ T by K]
%  options  - [optional] Options to use for the optimization, a fminunc process
%
% OUTPUTS:
%  parameters   - an outputvector consisting of the following, omit anything you don't ask for:
%                 [CONSTANT AR EXOGENOUS MA]
%  stderrors    - The estimated variance covariance matrix of the parameters
%  robustSE     - The White robust Variance Covaiance matrix for incorrect specification of the errors
%  SEregression - The standard errors of the regressions
%  errors       - A T-ar by 1 length vector of errors from the regression
%  LLF          - The log-likelihood of the regression
%  scores       - A T-ar by #params  matrix fo scores
%  likelihoods  - A T-ar by 1 vector of the individual log likelihoods for each obs
% 
%  uses ARMAXFILTER_LIKELIHOOD and ARMAXCORE.  You should MEX, mex 'path\armaxcore.c', the MEX source 
%  The included MEX is for R12 Windows and was compiled with VC++6. It gives a 20-30 times speed increase.
%
% Author: Kevin Sheppard
% kksheppard@ucsd.edu
% Revision: 1    Date: 3/29/2001


parameters=[];
stderrors=[];
robustSE=[];

T=length(y);
t=T-ar;
[regressand,lags]=lagmatrix(y,ar,constant);


%SOMETHING IS WRONG HERE
if nargin>4 & ~isempty(x) 
    TempX=x(ar+1:T,:);
    regressors=[lags';TempX']';
else
    regressors=lags;
end

% Use a few iterations of the zig-zag algorithm for starting values
d=1;
niter=0;
beta=regressors\regressand;
e=regressand-regressors*beta;
[e,elags]=lagmatrix(e,ma,0);
delta=elags\e;
while d>1e-2 & niter<=10
    oldparams=[beta;delta];
    elags=[zeros(ma,size(elags,2));elags];
    newregressand=regressand-elags*delta;
    beta=regressors\newregressand;
    e=newregressand-regressors*beta;
    [e,elags]=lagmatrix(e,ma,0);
    delta=elags\e;
    d=max(abs(oldparams-[beta;delta]));
    niter=niter+1;
end

[regressand,lags]=lagmatrix(y,ar,constant);
if nargin>4 & ~isempty(x) 
    TempX=x(ar+1:T,:);
    regressors=[lags';TempX']';
else
    regressors=lags;
end
if nargin <=5
    options=optimset('fminunc');
    options=optimset(options,'Display','iter','Diagnostics','on','LargeScale','off');
end

[parameters]=fminunc('armaxfilter_likelihood',[beta;delta],options, regressand , regressors, ar , ma);
if nargout >1
    stderrors=hessian('armaxfilter_likelihood',parameters,regressand , regressors, ar , ma);
    stderrors=stderrors^(-1);
    [LLF,errors,likelihoods]=armaxfilter_likelihood(parameters,regressand , regressors, ar , ma);
    LLF=-LLF;
    SEregression=sqrt(errors'*errors/(length(errors)-length(parameters)));
end
%Make the parameters into the correct form, Constant, AR, MA, X

if nargout > 2
   h=max(abs(parameters/2),1e-2)*eps^(1/3);
   hplus=parameters+h;
   hminus=parameters-h;
   likelihoodsplus=zeros(t,length(parameters));
   likelihoodsminus=zeros(t,length(parameters));
   for i=1:length(parameters)
      hparameters=parameters;
      hparameters(i)=hplus(i);
      [HOLDER, HOLDER1, indivlike] = armaxfilter_likelihood(hparameters,regressand , regressors, ar , ma);
      likelihoodsplus(:,i)=indivlike;
   end
   for i=1:length(parameters)
      hparameters=parameters;
      hparameters(i)=hminus(i);
      [HOLDER, HOLDER1, indivlike] = armaxfilter_likelihood(hparameters,regressand , regressors, ar , ma);
      likelihoodsminus(:,i)=indivlike;
   end
   scores=(likelihoodsplus-likelihoodsminus)./(2*repmat(h',t,1));
   scores=scores-repmat(mean(scores),t,1);
   B=scores'*scores;
   robustSE=stderrors*B*stderrors;
end
