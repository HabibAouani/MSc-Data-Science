function [D]=dif(d,n);
% PURPOSE: Generate a diffentiation matrix of degree n 
% ------------------------------------------------------------
% SYNTAX: D=dif(d,n);
% ------------------------------------------------------------
% OUTPUT: D: nxn diffentiation matrix
% ------------------------------------------------------------
% INPUT:  d : degree of differencing
%         n : dimension of filter matrix 
% ------------------------------------------------------------

% written by:
% Enrique M. Quilis
% Instituto Nacional de Estadistica
% Paseo de la Castellana, 183
% 28046 - Madrid (SPAIN)

switch d
case 0 % Levels
   D=eye(n);
case 1 % First differences
   % Generation of D: nxn
   %       1. Initialization: D=0
   %       2. Including [-1 1] vector 
   %	   3. Adding [1 0 .. 0] vector  
   %          It implies that the initial condition is z(0)=0
   D(1:n-1,1:n)=zeros(n-1,n);
   for i=1:n-1
      D(i,i)   = -1.00;
      D(i,i+1) =  1.00;
   end;
   e=zeros(1,n);
   e(1,1)=1;
   D=[e
      D ];
      clear e;
   case 2 % Second differences
   % Generation of D: nxn
   %       1. Initialization: D=0
   %       2. Including [1 -2 1] vector 
   %	   3. Adding [1 0 .. 0] vector twice
   %          It implies that the initial condition is z(0)=z(-1)=0       
   D(1:n-2,1:n)=zeros(n-2,n);
   for i=1:n-2
      D(i,i)   =  1.00;
      D(i,i+1) = -2.00;
      D(i,i+2) =  1.00;
   end;
   e=zeros(2,n);
   e(1,1)=1;
   e(2,2)=1;
   D=[e
      D ];
      clear e;
   otherwise 
      error (' *** IMPROPER DEGREE OF DIFFERENCING *** ');
   end

