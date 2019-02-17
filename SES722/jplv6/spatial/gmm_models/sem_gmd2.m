% PURPOSE: An example of using semgm1,semgm2 on a large data set   
%          GM estimation of the spatial error model                         
%---------------------------------------------------
% USAGE: sem_gmd2 (see sem_gmd for a small data set)
%---------------------------------------------------

clear all;
% NOTE a large data set with 3107 observations
% from Pace and Barry, takes around 150-250 seconds
load elect.dat;                    % load data on votes
y =  (elect(:,7)./elect(:,8));     % convert to proportions
x1 = log(elect(:,9)./elect(:,8));  % of population
x2 = log(elect(:,10)./elect(:,8));
x3 = log(elect(:,11)./elect(:,8));
latt = elect(:,5);
long = elect(:,6);
n = length(y);
x = [ones(n,1) x1 x2 x3];
clear x1; clear x2; clear x3;
clear elect;                % conserve on RAM memory

[j,W,j] = xy2cont(latt,long); % contiguity-based spatial Weight matrix

vnames = strvcat('voters','const','educ','homeowners','income');

% use defaults including lndet approximation
result = sem(y,x,W); % maximum likelihood estimates
prt(result,vnames);

result2 = semgm1(y,x,W);
prt(result2,vnames);

W2 = make_nnw(latt,long,1);    % nearest neighbor-based weight matrix
[j,W1,j] = xy2cont(latt,long); % contiguity-based spatial Weight matrix

result3 = semgm2(y,x,W1,W2);
prt(result3,vnames);


