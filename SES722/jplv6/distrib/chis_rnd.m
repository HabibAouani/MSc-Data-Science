function rno=chis_rnd(n,v)
% PURPOSE: generates random chi-squared deviates
%---------------------------------------------------
% USAGE:   rchi = chis_rnd(n,v)
% where:   n = the size of the vector to be generated
%          v = the degrees of freedom 
% RETURNS: n-vector with mean=v, variance=2*v
% --------------------------------------------------

% written by: James Albert, Bowling Green State University

% modified by: Jim LeSage 
% Because of problems with this very fast approach
% when generating very large vectors, these cases are done
% in 1000 observation chunks

if nargin ~= 2
error('Wrong # of arguments to chis_rnd');
end;
if ~(v>1)
error('chis_rnd: v must be > 1');
end;

nsize = 1000;
nobs = min(n,nsize);
%  generates a vector of n gamma(v) variates where v>1
a=(1/2)*(v)-1;
rn=zeros(nobs,1);
while prod(rn)==0,
   v1=-log(rand(nobs,1));
   v2=-log(rand(nobs,1));
          id=v2>=(a*(v1-log(v1)-1));
                        rn=rn+v1.*id.*(rn==0);
end;
rno=rn*v;

nleft = n - nsize;
nobs = min(nsize,nleft);
while nleft > 0
%  generate next nsize batch 
a=(1/2)*(v)-1;
rn=zeros(nobs,1);
while prod(rn)==0,
   v1=-log(rand(nobs,1));
   v2=-log(rand(nobs,1));
          id=v2>=(a*(v1-log(v1)-1));
                        rn=rn+v1.*id.*(rn==0);
end;
rno=[rno 
     rn*v];
nleft = nleft - nsize;
nobs = min(nsize,nleft);
end; % end of while nleft > 0 loop
