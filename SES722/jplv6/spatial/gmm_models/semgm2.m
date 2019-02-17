function results=SEMGM2(y,x,W1,W2)
% PURPOSE: computes Method of Moments Estimates for Spatial Error Model
%           using 2 weight matrices
%           y = XB + u,  u = p1*W1*u + p2*W2*u+e, using sparse algorithms
% ---------------------------------------------------
%  USAGE: results = gmm1(y,x,W1,W2)
%  where: y = dependent variable vector
%         x = independent variables matrix
%         W1 = sparse contiguity matrix (standardized) #1
%         W2 = sparse contiguity matrix (standardized) #2
% ---------------------------------------------------
%  RETURNS: a structure
%         results.meth          = 'semgm2'
%         results.beta          = bhat
%         results.tstat         = asymp t-stats
%         results.lambda        = lambdas
%         results.lambdatstat   = t-stat of lambdas (under normality assumption)
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


results.meth = 'semgm2';
time1 = 0; 
time2 = 0;

timet = clock; % start the clock for overall timing

%%Estimated OLS to get a vector of residuals
[N nvar]=size(x);results.nobs=N;results.nvar=nvar;
o1=ols(y,x);
e=o1.resid;
%Set arguements for MINZ function;
clear infoz2;
clear lambdahat;
infoz2.hess='marq';
infoz2.func = 'lsfunc';
infoz2.momt = 'nllsrho_minz2';
infoz2.jake = 'numz';%For numerical derivatives
infoz2.call='ls';
infoz2.prt=0;
infoz2.btol=1e-7;
infoz2.ftol=1e-10;
infoz2.matix=1000;

%Make inital guesses at parameter vector;
lambdavec = [.5;.5;o1.sige];


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
%se1 denotes e with a single dot (W*e);
%de1 denotes e with a double dot (W*W*e);
    se1=W1*e;     de1=W1*W1*e;
    se2=W2*e;     de2=W2*W2*e;

Gn=zeros(6,6);


%FIRST ROW OF TERMS
%P1                                     %P2                                                 %P1*P2
Gn(1,1)=(2/N)*e'*se1;                   Gn(1,2)=(2/N)*e'*se2;                             Gn(1,3)=(-1/N)*((se1'*se2)+(se2'*se1));
%P1^2                                   P2^2                                                sigma^2
Gn(1,4)=(-1/N)*se1'*se1;                Gn(1,5)=(-1/N)*se2'*se2;                            Gn(1,6)=1;


%SECOND ROW OF TERMS
%P1                                     %P2                                                 %P1*P2
Gn(2,1)=(2/N)*se1'*de1;                 Gn(2,2)=(1/N)*((se1'*W1*se2)+(se2'*W1'*se1));         Gn(2,3)=(-1/N)*((de1'*W1*se2)+(se2'*W1*de1));
%P1^2                                   P2^2                                                sigma^2
Gn(2,4)=(-1/N)*de1'*de1;                Gn(2,5)=(-1/N)*(se2'*W1'*W1*se2);                   Gn(2,6)=(1/N)*trace(W1'*W1);

%Third ROW OF TERMS
%P1                                             %P2                                           %P1*P2
Gn(3,1)=(1/N)*((se2'*W2*se1)+(se1'*W2'*se2));   Gn(3,2)=(2/N)*se2'*de2;                     Gn(3,3)=(-1/N)*((de2'*W2*se1)+(se1'*W2'*de2));

%P1^2                                           P2^2                                           sigma^2
Gn(3,4)=(-1/N)*(se1'*W2'*W2*se1);              Gn(3,5)=(-1/N)*de2'*de2;                      Gn(3,6)=(1/N)*trace(W2'*W2);

%Fourth Row of Terms
%P1                                             %P2                                           %P1*P2
Gn(4,1)=(1/N)*((se1'*W2*se1)+(de1'*se2));     Gn(4,2)=(1/N)*((se2'*W1*se2)+(se1'*de2));     Gn(4,3)=(-1/N)*((de1'*de2)+(se2'*W1'*W2*se1));
%P1^2                                           P2^2                                           sigma^2
Gn(4,4)=(-1/N)*(de1'*W2*se1);               Gn(4,5)=(-1/N)*(se2'*W1*de2);               Gn(4,6)=(1/N)*trace(W1'*W2);

%Fifth Row of Terms
%P1                                             %P2                                           %P1*P2
Gn(5,1)=(1/N)*((e'*de1)+(se1'*se1));        Gn(5,2)=(1/N)*((se2'*W1'*e)+(se1'*se2));       Gn(5,3)=(-1/N)*((de1'*se2)+(se2'*W1'*se1));
%P1^2                                           P2^2                                           sigma^2
Gn(5,4)=(-1/N)*(de1'*se1);                Gn(5,5)=(-1/N)*(se2'*W1'*se2);                    Gn(5,6)=0;

%Sixth row of terms
%P1                                             %P2                                           %P1*P2
Gn(6,1)=(1/N)*((se1'*W2'*e)+(se2'*se1));       Gn(6,2)=(1/N)*((de2'*e)+(se2'*se2));       Gn(6,3)=(-1/N)*((de2'*se1)+(se1'*W2'*se2));
Gn(6,4)=(-1/N)*(se1'*W2'*se1);                  Gn(6,5)=(-1/N)*(de2'*se2);                  Gn(6,6)=0;


%Make the Moment Conditions Vector
Gn2=[(1/N)*e'*e;(1/N)*se1'*se1;(1/N)*se2'*se2;(1/N)*se1'*se2;(1/N)*se1'*e;(1/N)*se2'*e;];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Pass arguements to MINZ function;
    [lambdahat,infoz2,stat]=minz(lambdavec,infoz2.func,infoz2,Gn,Gn2);

    lambdavec = [lambdahat(1);lambdahat(2);lambdahat(3)];
    %Estimate Parameters using EGLS;

    tmp = speye(N) - lambdahat(1)*sparse(W1) - lambdahat(2)*sparse(W2);
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
e1 = Gn2-Gn*[lambdahat(1);lambdahat(2);lambdahat(1)*lambdahat(2);lambdahat(1)^2;lambdahat(2)^2;lambdahat(3)];
se = sqrt(var(e1)*diag(stat.Hi));
lambdatstat1=lambdahat(1)./se(1);
lambdatstat2=lambdahat(2)./se(2);
results.lambdatstat=[lambdatstat1;lambdatstat2];
results.lambda=[lambdahat(1);lambdahat(2)];
results.GMsige=lambdahat(3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Estimate remaining parameters using EGLS;



results.yhat = x*results.beta;
results.resid = y - results.yhat;

B = speye(N) - results.lambda(1)*sparse(W1) - results.lambda(2)*sparse(W2); 
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

