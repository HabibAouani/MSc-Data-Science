function results=SEMGM1(y,x,W)
% PURPOSE: computes Generalized Moments Estimates for Spatial Error Model
%           using 1 weight matrix
%           y = XB + u,  u = lambda*W*u +e, using sparse algorithms
% ---------------------------------------------------
%  USAGE: results = SEMGM1(y,x,W)
%  where: y = dependent variable vector
%         x = independent variables matrix
%         W = sparse contiguity matrix (standardized)
% ---------------------------------------------------
%  RETURNS: a structure
%         results.meth          = 'semgm1'
%         results.beta          = bhat
%         results.tstat         = asymp t-stats
%         results.lambda        = lambda
%         results.lambdatstat   = t-stat of lambda (under normality assumption)
%         results.GMsige        = GM-estimated variance
%         results.yhat          = yhat
%         results.resid         = residuals
%         results.sige          = sige = e'(I-p*W)'*(I-p*W)*e/n
%         results.rsqr          = rsquared
%         results.rbar          = rbar-squared
%         results.se            = Standard errors from EGLS
%         results.nobs          = number of observations
%         results.nvar          = number of variables 
%         results.time1         = time for optimization
%         results.time2         = total time taken
% ---------------------------------------------------
% %  SEE ALSO: prt_semgm(results), sem, sem_g
% ---------------------------------------------------
% REFERENCES: Luc Anselin Spatial Econometrics (1988) pages 182-183.
% Kelejian, H., and  Prucha, I.R.  (1998). A Generalized Spatial Two-Stage
% Least Squares Procedure for Estimating a Spatial Autoregressive
% Model with Autoregressive Disturbances. \textit{Journal of Real
% Estate and Finance Economics},  17, 99-121.
% Documentation in microsoft word format included in the Econometrics Toolbox
% GENERALIZED MOMENTS ESTIMATION FOR FLEXIBLE SPATIAL ERROR MODELS:  
% A LIBRARY FOR MATLAB, by Shawn Bucholtz
% ---------------------------------------------------

% written by: Shawn Bucholtz
% SBUCHOLTZ@ers.usda.gov
% USDA-ERS-ISD-ADB

results.meth = 'semgm1';
time1 = 0; 
time2 = 0;

timet = clock; % start the clock for overall timing


%Estimated OLS to get a vector of residuals
[N nvar]=size(x);results.nobs=N;results.nvar=nvar;
o1=ols(y,x);
e=o1.resid;
%Set arguements for MINZ function;
clear infoz2;
clear lambdahat;
infoz2.hess='marq';
infoz2.func = 'lsfunc';
infoz2.momt = 'nllsrho_minz';
infoz2.jake = 'numz';%For numerical derivatives
infoz2.call='ls';
infoz2.prt=0;
infoz2.btol=1e-7;
infoz2.ftol=1e-10;
infoz2.matix=1000;

%Make inital guesses at parameter vector;
lambdavec = [.5;o1.sige];

%Begin Interation
econverge = e;
criteria = 0.001;
converge = 1.0;
iter = 1;
itermax = 100;

t0 = clock;

while (converge > criteria & iter < itermax)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input arguements into system of equations and moment
%conditions;
%The notation is simialar to the publication;
%se denotes e with a single dot (W*e);
%de denotes e with a double dot (W*W*e);

    se=W*e;
    de=W*W*e;
    Gn=zeros(3,3);
    Gn(1,1)=(2/N)*e'*se;Gn(1,2)=(-1/N)*se'*se; Gn(1,3)=1;
    Gn(2,1)=(2/N)*se'*de; Gn(2,2)=(-1/N)*se'*de; Gn(2,3)=(1/N)*trace(W'*W);
    Gn(3,1)=(1/N)*((e'*de)+(se'*se)); Gn(3,2)=(-1/N)*se'*de; Gn(3,3)=0;
    Gn2=[(1/N)*e'*e;(1/N)*se'*se;(1/N)*e'*se];

    %Pass arguments to MINZ function;
    [lambdahat,infoz2,stat]=minz(lambdavec,infoz2.func,infoz2,Gn,Gn2);

    lambdavec = [lambdahat(1);lambdahat(2)];
    
    %Estimate Parameters using EGLS;
    tmp = speye(N) - lambdahat(1)*sparse(W);
    xs = tmp*x;
    ys = tmp*y;
    results.beta = xs\ys;
    e = y - x*results.beta;

    converge = max(abs(e - econverge));%Check convergence
    econverge = e;

    iter = iter + 1;
end;
time1 = etime(clock,t0);

%Compute stats from minimization;
e1 = Gn2-Gn*[lambdahat(1);lambdahat(1)^2;lambdahat(2)];
vare1 = std(e1)*std(e1);
se = sqrt(vare1*diag(stat.Hi));
results.lambdatstat=lambdahat(1)./se(1);
results.GMsige=lambdahat(2);


%Estimate remaining parameters using EGLS;

results.lambda=lambdahat(1);
results.yhat = x*results.beta;
results.resid = y - results.yhat;

B = speye(N) - results.lambda*sparse(W); 
epe = e'*B'*B*e;
results.sige = (1/N)*epe;
xpx(1:nvar,1:nvar) = (1/results.sige)*x'*B'*B*x;
results.tstat = results.beta./(sqrt(diag(inv(xpx))));
results.se = sqrt(diag(inv(xpx)));
sigu = results.sige*N;
ym = y - mean(y);
rsqr1 = sigu;
rsqr2 = ym'*ym;
results.rsqr = 1.0 - rsqr1/rsqr2; % r-squared
rsqr1 = rsqr1/(N-nvar);
rsqr2 = rsqr2/(N-1.0);
if rsqr2 ~= 0
results.rbar = 1 - (rsqr1/rsqr2); % rbar-squared
else
    results.rbar = results.rsqr;
end;

time2 = etime(clock,timet);

results.time1 = time1;
results.time2 = time2;

