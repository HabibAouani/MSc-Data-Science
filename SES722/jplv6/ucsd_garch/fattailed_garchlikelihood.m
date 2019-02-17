function [LLF, h, likelihoods] = fattailed_garchlikelihood(parameters , data , p , q, errortype)
% PURPOSE: likelihood for fattailed garch
[r,c]=size(parameters);
if c>r
   parameters=parameters';
end


parameters(find(parameters <= 0)) = realmin;

constp=parameters(1);
archp=parameters(2:p+1);
garchp=parameters(p+2:p+q+1);
if errortype ~=1;
   nu = parameters(p+q+2);
   parameters = parameters(1:p+q+1);
end



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
%for t = (m + 1):T
%   h(t) = parameters' * [1 ; data(t-(1:p)).^2;  h(t-(1:q)) ];
%end



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
