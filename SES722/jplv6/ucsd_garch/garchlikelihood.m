function [LLF, grad, hessian, h, scores, robustse] = garchlikelihood(parameters , data , p , q)
% PURPOSE: [LLF, grad, hessian, h, scores, robustse] = garchlikelihood(parameters , data , p , q)
% 
% Inputs:
%
% parameters:   A vector of GARCH process aprams of the form [constant, arch, garch]
% data:         A set of zero mean residuals
% p:            The lag order length for ARCH
% q:            The lag order length for GARCH
%
% Outputs
% LLF:          Minus 1 times the log likelihood
% grad:         The analytic gradient at the parameters
% hessian:      The analytical hessian at the parameters
% h:            The time series of conditional variances implied by the parameters and the data
% scores:       A matrix, T x #params of the individual scores
% robustse:     Quasi-ML Robust Standard Errors(Bollweslev Wooldridge)
%
% This is a helper function for garchpq
%
%
% Author: Kevin Sheppard
% kksheppard@ucsd.edu
% Revision: 1    Date: 10/15/2000
%
%

parameters(find(parameters <= 0)) = realmin;


constp=parameters(1);
archp=parameters(2:p+1);
garchp=parameters(p+2:p+q+1);



if isempty(q)
    m=p;
else
    m  =  max(p,q);   
end

Tau=size(data,1);
stdEstimate =  std(data,1);                      
data        =  [stdEstimate(ones(m,1)) ; data];  
T           =  size(data,1);                    

h  =  data(1).^2;
h  =  [h(ones(m,1)) ; zeros(T-m,1)];   % Pre-allocate the h(t) vector.

h=garchcore(h,data,parameters,p,q,m,T);
% REMOVE THE COMMENTS IF YOU WANT TO NOT USE THE MEX FILE ADN COMMENT THE LINE ABOVE
%for t = (m + 1):T
%   h(t) = parameters' * [1 ; data(t-(1:p)).^2;  h(t-(1:q)) ];
%end


t    = (m + 1):T;
LLF  =  sum(log(h(t))) + sum((data(t).^2)./h(t));
LLF  =  0.5 * (LLF  +  (T - m)*log(2*pi));



% Now Calculate the Gradiant


if nargout >= 2
    d=ones(size(h));
    e=ones(size(h,1),p)*stdEstimate;
    f=ones(size(h,1),q)*stdEstimate;
    for i=t
        d(i)=1+d(i-1:-1:i-q)'*garchp;
        for j=1:p
            e(i,j)=data(i-j)^2+garchp'*e(i-1:-1:i-q,j);
        end
        
        for j=1:q
            f(i,j)=h(i-j)+garchp'*f(i-1:-1:i-q,j);  
        end
    end
    Base=(((data.^2)./h)-1)./(2*h);
    Base=repmat(Base,1,(1+p+q));
    gradsum=Base.*[d';e';f']';
    dht=[d';e';f']';
    grad=-sum(gradsum(t,:))';
    scores=gradsum(t,:);
end

if nargout >= 3
    hessian=zeros(1+p+q);
    for i=t
        hessian=hessian+(dht(i,:)'*dht(i,:))*(data(i)^2/(2*h(i)^3));
    end
    A=hessian/Tau;
    Bscores=scores-repmat(mean(scores),Tau,1);
    B=(Bscores'*Bscores)/Tau;
    robustse=(A^-1)*B*(A^-1)*(T^-1);
    h=h(t);   
end

