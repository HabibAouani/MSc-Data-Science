function random = exppowrnd(x,nu) 
% PURPOSE: Generates Deviates from the Exponential Power Distribution
% where x is the number of deviates wanted and nu is the shape parameter
%
% USAGE:  random = exppowrnd(x,nu) 
% 
% NOTE nu must be greater than 1
%
% Uses an acceptance rejection method
% 
% The exponential power dist'n pdf is given by:
%
% f(x)=Kd * exp (-|x|^nu)
% KD = inv(2 * gamma (1+(1/nu) ) )
%
% Taken from Tadikamalla 1980
%
% Written by: Kevin Sheppard      21-November-2000
% Included in the ucsd_garch toolbox and the JPL library
% Requires the JPL toolbox



A = 1/nu;
B = A^A;
dummy =1;

random=zeros(x,1);

for i=1:x
   while dummy == 1
      u = rand;
      if u > .5
         x=B*(-log(2*(1-u)));
      else
         x=B*log(2*u);
      end
      if log(rand)<=(-abs(x)^alpha + abs(x)/B - 1 + A)
         random(i)=x;
         break
      end
   end
end

   
      