function [LLF,Ht, likelihoods] = multigarch_likelihood(parameters,data,p,q,garchtype, errortype)
% PURPOSE: multigarch likelihood

parameters(find(parameters(1:1+p+q) <= 0)) = realmin;
constp=parameters(1);
archp=parameters(2:p+1);
garchp=parameters(p+2:p+q+1);

remainingparams=parameters(p+q+2:length(parameters));

if garchtype == 1
   lambda=2;
   nu=2;
   b=0;
   c=0;
elseif garchtype == 2
   lambda=1;
   nu=1;
   b=0;
   c=remainingparams(1);
elseif garchtype == 3
   lambda=1;
   nu=1;
   b=remainingparams(1);
   c=remainingparams(2);
elseif garchtype == 4
   lambda=remainingparams(1);
   nu=lambda;
   b=0;
   c=0;
elseif garchtype == 5
   lambda=2;
   nu=2;
   b=remainingparams(1);
   c=0;
elseif garchtype == 6
   lambda=remainingparams(1);
   nu=lambda;
   b=0;
   c=remainingparams(2);
elseif garchtype == 7
   lambda=remainingparams(1);
   nu=lambda;
   b=remainingparams(2);
   c=remainingparams(3);
end

if errortype ~=1;
   nu2 = remainingparams(length(remainingparams));
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

fepsilon=abs(data-b)+c*(data-b);

h  =  data(1);
h  =  [h(ones(m,1)) ; zeros(T-m,1)];   % Pre-allocate the h(t) vector.

garchparameters=parameters(1:p+q+1);

for t = (m + 1):T
   h(t) = (constp   +  archp'*((fepsilon(t-(1:p))).^nu)+   garchp'*((h(t-(1:q))).^lambda))^(1/lambda);
end




t    = (m + 1):T;
h(t)=h(t).^2;


Tau = T-m;
LLF = 0;
t = (m + 1):T;
if errortype == 1
   LLF  =  sum(log(h(t))) + sum((data(t).^2)./h(t));
   LLF  =  0.5 * (LLF  +  (T - m)*log(2*pi));
elseif errortype == 2
   LLF = Tau*gammaln(0.5*(nu2+1)) - Tau*gammaln(nu2/2) - Tau/2*log(pi*(nu2-2));
   LLF = LLF - 0.5*sum(log(h(t))) - ((nu2+1)/2)*sum(log(1 + (data(t).^2)./(h(t)*(nu2-2)) ));
   LLF = -LLF;
else
   Beta = (2^(-2/nu2) * gamma(1/nu2)/gamma(3/nu2))^(0.5);
   LLF = (Tau * log(nu2)) - (Tau*log(Beta)) - (Tau*gammaln(1/nu2)) - Tau*(1+1/nu2)*log(2);
   LLF = LLF - 0.5 * sum(log(h(t))) - 0.5 * sum((abs(data(t)./(sqrt(h(t))*Beta))).^nu2);
   LLF = -LLF;
end

if nargout > 2
   likelihoods=zeros(size(T));
   if errortype == 1
      likelihoods = 0.5 * ((log(h(t))) + ((data(t).^2)./h(t)) + log(2*pi));
      likelihoods = -likelihoods;
   elseif errortype == 2
      likelihoods = gammaln(0.5*(nu2+1)) - gammaln(nu2/2) - 1/2*log(pi*(nu2-2))...
         - 0.5*(log(h(t))) - ((nu2+1)/2)*(log(1 + (data(t).^2)./(h(t)*(nu2-2)) ));
      likelihoods = -likelihoods;
   else
      Beta = (2^(-2/nu2) * gamma(1/nu2)/gamma(3/nu2))^(0.5);
      likelihoods = (log(nu2)/(Beta*(2^(1+1/nu2))*gamma(1/nu2))) - 0.5 * (log(h(t))) ...
         - 0.5 * ((abs(data(t)./(sqrt(h(t))*Beta))).^nu2);
      likelihoods = -likelihoods;
   end
end


Ht=h(t);


if isnan(LLF)
   LLF=10e+6;
end
