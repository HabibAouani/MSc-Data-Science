function errors=armaxcore(e,yhat,y,parameters,ar,ma,T)
paramlen=length(parameters);
for t = (ma + 1):T
   e(t)=y(t)-yhat(t)-parameters(ar+1:paramlen)'*[e((t-1):-1:(t-ma))];
end
errors=e;
