function [lambda, nu, b, c, garchtype]=multi_garch_paramsetup(type);
% PURPOSE: multigraph parameter parsing
if strcmp(type,'GARCH');
   lambda=2;
   nu=2;
   b=0;
   c=0;
   indicator=[0 0 0 0]';
   garchtype = 1;
elseif strcmp(type,'TGARCH');
   lambda=1;
   nu=1;
   b=0;
   c=0;
   indicator=[0 0 0 1]';
   garchtype = 2   ;
elseif strcmp(type,'AVGARCH');
   lambda=1;
   nu=1;
   b=0;
   c=0;
   indicator=[0 0 1 1]';      
   garchtype = 3   ;
elseif strcmp(type,'NGARCH');
   lambda=2.3;
   nu=lambda;
   b=0;
   c=0;
   indicator=[1 0 0 0]';         
   garchtype = 4   ;
elseif strcmp(type,'NAGARCH');
   lambda=2;
   nu=2;
   b=0;
   c=0;
   indicator=[0 0 1 0]';            
   garchtype = 5;
elseif strcmp(type,'APGARCH');
   lambda=2;
   nu=lambda;
   b=0;
   c=0;
   indicator=[1 0 0 1]';   
   garchtype = 6      ;
elseif strcmp(type,'ALLGARCH');
   lambda=2;
   nu=lambda;
   b=0;
   c=.1;
   indicator=[1 0 1 1]';
   garchtype = 7;      
elseif strcmp(type,'EGARCH');
   lambda=2;
   nu=lambda;
   b=0;
   c=0;
   indicator=[1 0 1 1]';
   garchtype = 0;  
else
   error('Garch type must be one of the specified types, Please check spelling, ALL CAPS');

end


