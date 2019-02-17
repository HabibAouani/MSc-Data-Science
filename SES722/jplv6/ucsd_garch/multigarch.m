function [parameters, likelihood, stderrors, robustSE, ht, scores]=multigarch(data,p,q,type,errors,options, startingvals)
% PURPOSE: This is a multiuse univariate GARCH function which can estimate 
% GARCH(you should use garchpq though), EGARCH(Nelson), Threshold GARCH(Zakoian), 
% Absolute Value GARCH(Taylor/Schwert), Non-Linear Asymetric GARCH(Engle Ng), 
% GJR-GARCH(GJR), Nonlinear GARCH(Higgins Bera),
% and asymetric power GARCH(Ding Engle and Granger).
% USAGE:
% [parameters, likelihood, stderrors, robustSE, ht, scores]=multigarch(data,p,q,type,errors,options, startingvals)
%
% This proceedure estimates conditional volatility of the following form:
% 
% h(t)^(lambda)-1                                                 h(t-1)^(lambda)-1
% ------------  = omega + a*h(t-1)^(lambda)+f(data(t-1))^(nu)+ b*-------------------
%     lambda                                                           lambda
%
% f(data(t))=abs(data(t)-b) - c*(data(t)-b)
%
% INPUTS:
%  data: Zero Mean series of regression residuals or other zero mean series
%  p :  The order of the ARCH(innovations) process
%  q :  The order of the GARCH process
%  r :  the order of the threshold effects(should be almost always 1)
%  type :  A string telling the proc which type of model is to be estimated
%          Can be one of the following(note: ALL CAPS)
%
%          'GARCH'    -  Normal GARCH Model(see garchpq instead) OK
%          'EGARCH'   -  Exponential GARCH                      OK
%          'TGARCH'   -  Threshold GARCH                        OK
%          'AVGARCH'  -  Absolute Value GARCH                   OK
%          'NGARCH'   -  Non-linear GARCH                       OK
%          'GJRCARCH' -  GJR Representation                     OK
%          'NAGARCH'  -  Non-Linear Asymetric GARCH             OK
%          'APGARCH'  -  Asymetric Power GARCH                  OK
%          'ALLGARCH' -  Asymetric Power GARCH with Centering parameter OK
%
% OUTPUTS:
%   parameters: a 1+p+q+special column vector of estimated model parameters, the size
%               of special depends on the model being estimated
%   logl: The log-likelihood of the likelihood function.
%
%   the special parameter will contain estimates of the following, in this order
%   (non-estimated parameters are not reported), range is in paranthesis
%
%   lambda(0, infty] -  this is the parameter which determines the power of sigma being estimaded(i.e. 2 for GARCH)
%   nu(0, infty)     -  this parameter determines the shape of the news impact curve , Convex if < 1.
%   b(-infty, infty) -  The centering parameter for the effect of the new impact on volatility
%   c(abs(c)<=1)     -  A rotating parameter for assymetry in the new impact on volatility
%
% This program is in no small part influenced by the work of 
% L. Hentschel J. of Empirical Finance 95
%
% Written By: Kevin Sheppard Date:10/25/00
% kksheppard@ucsd.edu
%


if strcmp(errors,'NORMAL') | strcmp(errors,'STUDENTST') | strcmp(errors,'GED')
    if strcmp(errors,'NORMAL') 
        errortype = 1;
    elseif strcmp(errors,'STUDENTST') 
        errortype = 2;
    else
        errortype = 3;
    end
else
    error('error must be one of the three strings NORMAL, STUDENTST, or GED');
end

if size(data,2) > 1
    error('Data series must be a column vector.')
elseif isempty(data)
    error('Data Series is Empty.')
end


if (length(q) > 1) | any(q <= 0)
    error('Q must ba a single positive scalar or an empty vector for ARCH.')
end

if (length(p) > 1) | any(p <  0)
    error('P must be a single positive number.')
elseif isempty(p)
    error('P is empty.')
end


[lambda, nu, b, c, garchtype]=multi_garch_paramsetup(type);


if (nargin <= 5) | isempty(options)
    options  =  optimset('fmincon');
    options  =  optimset(options , 'TolFun'      , 1e-004);
    options  =  optimset(options , 'Display'     , 'iter');
    options  =  optimset(options , 'Diagnostics' , 'on');
    options  =  optimset(options , 'LargeScale'  , 'off');
    options  =  optimset(options , 'MaxFunEvals' , 400*20);
end



LB         =  [];     
UB         =  [];     
sumA =  [-eye(1+p+q); ...
        0  ones(1,p)  ones(1,q)];
sumB =  [zeros(1+p+q,1);...
        1-2*optimget(options, 'TolCon', 1e-6)];                          


if isempty(q)
    q=0;
    m=p;
else
    m  =  max(p,q);   
end


if nargin<=6
    guess  =  1/(2*m+1);
    alpha  =  .15*ones(p,1)/p;
    beta   =  .75*ones(q,1)/q;
    omega  =  (1-(sum(alpha)+sum(beta)))*cov(data);  %set the uncond = to its expection
else
    omega=startingvals(1);
    alpha=startingvals(2:p+1);
    beta=startingvals(p+2:p+q+1);
end
startingvalues=[omega ; alpha ; beta];



[sumA, sumB, startingvalues, LB, UB]=multi_garch_constraints(garchtype, startingvalues, sumA, sumB, p , q, data, type);


if (nargin <= 5) | isempty(options)
    options  =  optimset('fmincon');
    options  =  optimset(options , 'TolFun'      , 1e-004);
    options  =  optimset(options , 'Display'     , 'iter');
    options  =  optimset(options , 'Diagnostics' , 'on');
    options  =  optimset(options , 'LargeScale'  , 'off');
    numberOfVariables=size(sumA,2);
    options  =  optimset(options , 'MaxFunEvals' , 400*numberOfVariables);
end

if strcmp(type,'EGARCH');
    [parameters, likelihood, stderrors, robustSE, ht, scores]=egarch(data,p,q,errors, options);
    return
end

newoptions  =  optimset('fmincon');
newoptions  =  optimset(newoptions , 'TolFun'      , 1e-1);
newoptions  =  optimset(newoptions , 'Display'     , 'off');
newoptions  =  optimset(newoptions , 'Diagnostics' , 'off');
newoptions  =  optimset(newoptions , 'LargeScale'  , 'off');
newoptions  =  optimset(newoptions , 'MaxFunEvals' , 600*size(sumA,2));
startingvalues(1:1+p+q)=garchpq(data,p,q,startingvalues(1:1+p+q),newoptions);


if strcmp(errors,'STUDENTST')
   sumA=[sumA';zeros(1,size(sumA,1))]';
   nuconst=zeros(1,size(sumA,2));
   nuconst(size(sumA,2))=-1;
   sumA=[sumA;nuconst];
   sumB=[sumB;-2.1];
   startingvalues=[startingvalues;20];
elseif strcmp(errors,'GED')
   sumA=[sumA';zeros(1,size(sumA,1))]'
   nuconst=zeros(1,size(sumA,2));
   nuconst(size(sumA,2))=-1;
   sumA=[sumA;nuconst];
   sumB=[sumB;-1.1];
   startingvalues=[startingvalues;2];
end



%Estimate the parameters.
[parameters, LLF, EXITFLAG, OUTPUT, LAMBDA, GRAD, HESSIAN] =  fmincon('multigarch_likelihood', startingvalues ,sumA  , sumB ,[] , [] , LB , UB,[],options,data, p , q, garchtype, errortype);

[logl, h]=multigarch_likelihood(parameters,data, p , q, garchtype, errortype);
if EXITFLAG<=0
   EXITFLAG
   fprintf(1,'Not Sucessful! \n')
end

%parameters(find(parameters    <  0)) = 0;          
%parameters(find(parameters(1) <= 0)) = realmin;    
%[likelihood, grad, hessian, ht, scores, robustSE] = garchlikelihood(parameters , data , p , q);
%stderrors=hessian^(-1);
%likelihood=-likelihood;

[likelihood, ht]=multigarch_likelihood(parameters,data,p,q,garchtype,errortype);

t=size(data,1);
hess = hessian('multigarch_likelihood',parameters,data,p,q,garchtype,errortype);
[likelihood, ht]=multigarch_likelihood(parameters,data,p,q,garchtype,errortype);
likelihood=-likelihood;
stderrors=hess^(-1);

if nargout > 4
    h=min(abs(parameters/2),max(parameters,1e-2))*eps^(1/3);
    hplus=parameters+h;
    hminus=parameters-h;
    likelihoodsplus=zeros(t,length(parameters));
    likelihoodsminus=zeros(t,length(parameters));
    for i=1:length(parameters)
        hparameters=parameters;
        hparameters(i)=hplus(i);
        [HOLDER, HOLDER1, indivlike] = multigarch_likelihood(hparameters,data,p,q,garchtype,errortype);
        likelihoodsplus(:,i)=indivlike;
    end
    for i=1:length(parameters)
        hparameters=parameters;
        hparameters(i)=hminus(i);
        [HOLDER, HOLDER1, indivlike] = multigarch_likelihood(hparameters,data,p,q,garchtype,errortype);
        likelihoodsminus(:,i)=indivlike;
    end
    scores=(likelihoodsplus-likelihoodsminus)./(2*repmat(h',t,1));
    scores=scores-repmat(mean(scores),t,1);
    B=scores'*scores;
    robustSE=stderrors*B*stderrors;
end
