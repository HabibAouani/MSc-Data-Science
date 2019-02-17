function results = bma_g(ndraw,y,x1,x2,prior)
% PURPOSE: Bayes model averaging estimates of Raftery, Madigan and Hoeting
%-----------------------------------------------------------------
% USAGE:    result = bma_g(ndraw,y,x1,x2,prior)
%       or: result = bma_g(ndraw,y,x1)
% where:  ndraw = # of draws to carry out 
%             y = dependent variable vector (nobs x 1)
%            x1 = continuous explanatory variables (nobs x k1)
%            x2 = (optional) dummy variables (nobs x k2)
%         prior = (optional) structure variable with prior information
%     prior.nu  = nu hyperparameter  (see NOTES)
%     prior.lam = lam hyperparameter (see NOTES)
%     prior.phi = phi hyperparameter (see NOTES)
%-----------------------------------------------------------------
% RETURNS: a structure results:
%     results.meth  = 'bma'
%     results.nmod  = # of models visited during sampling
%     results.beta  = bhat averaged over all models
%     results.tstat = t-statistics averaged over all models
%     results.prob  = posterior prob of each model (nmod x 1)
%     results.model = indicator variables for each model (nmod x k1+k2)
%     results.yhat  = yhat averaged over all models
%     results.resid = residuals based on yhat averaged over models
%     results.sige  = averaged over all models
%     results.rsqr  = rsquared based on yhat averaged over models
%     results.nobs  = nobs
%     results.nvar  = nvars = k1+k2
%     results.k1    = k1, # of continuous explanatory variables
%     results.k2    = k2, # of dichotomous variables
%     results.y     = y data vector
%     results.visit = visits to each model during sampling (nmod x 1)
%     results.time  = time taken for MCMC sampling
%     results.ndraw = # of MCMC sampling draws
%     results.nu    = prior hyperparameter
%     results.phi   = prior hyperparameter
%     results.lam   = prior hyperparameter
%--------------------------------------------------
% NOTES: prior is: B = N(m,sig*V), nu*lam/sig = chi(nu)
%        m = (b0,0,...,0), b0 = ols intercept estimate
%        V = diag[var(y), phi^2/var(x1), phi^2/var(x2) ...]
%        defaults: nu=4, lam = 0.25, phi=3
%--------------------------------------------------
% SEE ALSO: prt(results), plt(results)
%---------------------------------------------------
% REFERENCES: Raftery, Madigan and Hoeting (1997) 'Bayesian model averaging
% for linear regression models', JASA 92, pp. 179-191
%-----------------------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com

% bug fixes suggested by:
% Davide Pettenuzzo
% Ph.D student 
% Bocconi University
% 20136 Milan Italy
% email:davide.pettenuzzo@uni-bocconi.it
% incorporated April, 2003.


% error checking
if nargin == 5
 dflag = 1;
 [nobs1 k2] = size(x2);
 if k2 == 0; dflag = 0; end; % no dummy variables
 [nobs2 k1] = size(x1);
 [nobs3 junk] = size(y);
 if dflag == 1
  if nobs1 ~= nobs2; error('bma_g: x1 and x2 need same # of observations');end;
 else
  if nobs2 ~= nobs3; error('bma_g" x1 and y need same # of observations');end;
 end; % end of if dflag-else

 if ~isstruct(prior)
    error('bma: must supply the prior as a structure variable');
 else
 fields = fieldnames(prior);
 nf = length(fields);
 % set defaults
 nu = 4; lam = 0.25; phi = 3;
  for i=1:nf
    if strcmp(fields{i},'nu')
        nu = prior.nu; 
    elseif strcmp(fields{i},'lam')
        lam = prior.lam;
    elseif strcmp(fields{i},'phi')
        phi = prior.phi;
    end;
  end;
 end;

elseif nargin == 4 % case of possible dummy variables
 % set defaults
 nu = 4; lam = 0.25; phi = 3;
 dflag = 1;
 [nobs1 k2] = size(x2);
 if k2 == 0; dflag = 0; end; % no dummy variables
 [nobs2 k1] = size(x1);
 [nobs3 junk] = size(y);
 if dflag == 1
  if nobs1 ~= nobs2; error('bma_g: x1 and x2 need same # of observations');end;
 else
  if nobs2 ~= nobs3; error('bma_g" x1 and y need same # of observations');end;
 end; % end of if dflag-else

elseif nargin == 3
dflag = 0;
 % set defaults
 nu = 4; lam = 0.25; phi = 3;
 
else 
 error('Wrong # of arguments to bma_g');
end;

[nobs nv1] = size(x1);
if dflag == 1
[nobs nv2] = size(x2);
x = [x1 x2];
else
    nv2 = 0;
    x = x1;
end;

nvar = nv1+nv2;


% find intercept ols estimate for bprior
res = ols(y,[ones(nobs,1) x]);
b0 = res.beta(1);
bprior = zeros(nvar+1,1);
bprior(1,1) = b0;


% scale y data
ys = y - mean(y)*ones(nobs,1);
ys = ys/std(y);
% scale x1 data
xs1 = x1 - matmul(mean(x1),ones(nobs,nv1));
xs1 = matdiv(xs1,std(x1));
xs2 = [];
if dflag == 1
% scale x2 data
xs2 = x2 - matmul(mean(x2),ones(nobs,nv2));
end;

vsave = zeros(ndraw,nvar);
visits = zeros(ndraw,1);
lposts = zeros(ndraw,1);

vtmp=zeros(nvar,1);
for v=1:nvar
    vtmp(v)=bino_rnd(1,0.5,1,1);
end
vin=selif(seqa(1,1,nvar).*vtmp,vtmp)';
vout=delif(seqa(1,1,nvar)-seqa(1,1,nvar).*vtmp,vtmp)'; 
 

%<====================== start draws
t0 = clock;
for i=1:ndraw; 
    
% choose new model
[vinew vonew] = sample(vin,vout);
for j=1:length(vinew);
vsave(i,vinew(1,j)) = 1.0;
end;

[j visits] = find_new(i,vsave,vinew,visits);

if i == 1 % first draw compute logpost for initial model
lposts(i,1) = bmapost(ys,xs1,xs2,vin,nu,lam,phi);
post_old = lposts(i,1);
end;

if visits(i,1) ~= 0 % we found a new model
post_new = bmapost(ys,xs1,xs2,vinew,nu,lam,phi);
lposts(i,1) = post_new;

else
    post_new = lposts(j,1);

end; % end of if-else visits

bf = exp(post_new-post_old);

 if bf >=1; 
     flag = 1; 
 else 
     flag = bino_rnd(1,bf,1,1); 
 end;


 if flag == 1 % change models
 vin = vinew;
 vout = vonew;
 post_old = post_new;
 end;


end; %<=============== end of draws
time = abs(etime(clock,t0));

% compute posterior probabilities
posts = exp(lposts);
psum = sum(posts);
postprob = posts/psum;

% find unique models
uindex = find(visits ~= 0);
tmp = visits(uindex);
prob = posts(uindex);
postprob = prob/sum(prob);
[posto posti] = sort(postprob);
visito = tmp(posti);
tmp = vsave(uindex,:);
modelo = tmp(posti,:);

% compute bhat, sige, yhat averaged
% over unique models

nmodels = length(uindex);
bavg = zeros(1,nvar+1); % bhat
tavg = zeros(1,nvar+1); % t-tstatistics
savg = 0.0;             % sige

for i=1:nmodels
vin = [];
cnt = 1;  
for j=1:nvar
    if modelo(i,j) ~= 0
        vin(1,cnt) = j;
        cnt = cnt+1;
    end;
end;

% do regression using model explanatory variables
% and weight by posterior probabilities
res = ols(y,[ones(nobs,1) x(:,vin)]);
cnt = 2;
bavg(1,1) = bavg(1,1) + res.beta(1)*posto(i,1);
tavg(1,1) = tavg(1,1) + res.tstat(1)*posto(i,1);
for k=1:nvar
    if modelo(i,k) ~= 0 
       bavg(1,k+1) = bavg(1,k+1) + res.beta(cnt)*posto(i,1);   
       tavg(1,k+1) = tavg(1,k+1) + res.tstat(cnt)*posto(i,1);
       cnt = cnt+1;
   end;
end;
savg = savg + res.sige*posto(i,1);
end;

% now find y-hat weighted by posterior probability for the model
yhat = zeros(nobs,1);
yhat = [ones(nobs,1) x]*bavg';

% r-squared
resid = y - yhat;
sigu = resid'*resid;
ym = y - ones(nobs,1)*mean(y);
rsqr1 = sigu;
rsqr2 = ym'*ym;
rsqr = 1.0 - rsqr1/rsqr2; % r-squared

% fill-in results structure
results.meth = 'bma_g';
results.nmod = nmodels;
results.beta = bavg';
results.tstat = tavg';
results.prob = posto;
results.model = modelo;
results.yhat = yhat;
results.sige = savg;
results.resid = resid;
results.rsqr = rsqr;
results.nobs = nobs;
results.nvar = nvar;
results.k1 = nv1;
results.k2 = nv2;
results.y = y;
results.visit = visito;
results.ndraw = ndraw;
results.nu = nu;
results.phi = phi;
results.lam = lam;
results.time = time;


function lpost = bmapost(y,x1,x2,vin,nu,lamda,phi)
% PURPOSE: evaluates log posterior of bma model
%          (Bayesian model averaging)
%-----------------------------------------------------------
% USAGE: lpost = bmapost(y,x1,x2,vin,nu,lamda,phi)
% where:   y = dependent variable vector (nobs x 1)
%         x1 = explanatory variables matrix (nobs x k1)
%         x2 = dummy variables matrix (nobs x k2)
%        vin = a 1xk vector of columns to use from x, e.g. [1 3 5]
%              k = k1+k2
% nu,lam,phi = prior hyperparameters 
%    lamda = prior hyperparameter
%      phi = prior hyperparameter
% prior: B = N(m,sig*V), nu*lam/sig = chi(nu)
% m = (b0,0,...,0), b0 = ols intercept estimate
% V = diag[var(y), phi^2/var(x1), phi^2/var(x2) ...] for x1
% V =  (phi^2)*[(1/nobs)*inv(x2'*x2)] for x2
% defaults: nu=4, lam = 0.25, phi=3
%-----------------------------------------------------------
% RETURNS: lpost = log of the posterior
%-----------------------------------------------------------
% NOTES: data y,x1 should be centered and scaled by std deviations
%             x2 should be centered
%             so the default prior settings work well in general
%-----------------------------------------------------------
% REFERENCES: Raftery and Madigan (1997) 'Bayesian model averaging
% for linear regression models', 92, pp. 179-191
% ----------------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jpl@jpl.econ.utoledo.edu

vin=sort(vin); 

[nobs junk] = size(y);
[junk nv1] = size(x1);
[junk nv2] = size(x2);
if nv2 == 0
   dflag = 0;
 else
   dflag = 1;   
end;

phi = phi*phi;

if dflag == 1
x2i = phi*((1/nobs)*inv(x2'*x2));
x = [x1 x2];
else
x = x1;
end;

nvar = length(vin);
v1 = nvar;
for i=1:nvar
    if vin(1,i) >= nv1
        v1 = i; % # of variables in x1
    end;
end;    

xt = x(:,vin);

bp = std(y)*std(y);
bp = [bp
      zeros(nvar,1)];
      
v = phi*eye(nvar+1);
v(1,1) = std(y)*std(y);
for i=2:v1+1;
sx = std(xt(:,i-1));
v(i,i) = v(i,i)/(sx*sx);
end;
if dflag == 1
 for i=v1+1:nvar+1
 cnti = 1;
  for j=v1+1:nvar+1
  cntj = 1;
  v(i,j) = x2i(cnti,cntj);
  cntj = cntj+1;
  end;
 cnti = cnti+1;
 end;
end;

xmat = [ones(nobs,1) xt];

xpx = xmat*v*xmat';
ixvx = eye(nobs) + xpx;
ix = inv(ixvx);
divs = sqrt(det(ixvx));
denom = (y - xmat*bp)'*ix*(y-xmat*bp);
lpost = gammaln((nobs+nu)/2) + log(nu*lamda)*(nu/2)-log(pi) ...
        *(nobs/2) - gammaln(nu/2)-log(divs)-((nu+nobs)/2)*log(denom);
  
function [j,visits] = find_new(i,vsave,vinew,visits)
% PURPOSE: determines if the variables in vinew represent a new model
%          (called by bma_g)
%-------------------------------------------------------
% USAGE: [j,visits] = find_new(i,vsave,vinew,visits)
% where:        i   = size of vsave to search = draw #
%             vsave = (i x nvar) matrix of indicators for models
%             vinew = (1 x k1) vector with current model indicators
%            visits = (i x nvar) matrix for recording # of visits to a model
%-------------------------------------------------------
% RETURNS:      j = index to an old model found
%          visits = matrix recording visits to old models
%-------------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jpl@jpl.econ.utoledo.edu

[junk nvar] = size(vsave);
vitmp = zeros(1,nvar);
for k=1:nvar
    for j=1:length(vinew)
      if vinew(1,j) == k
        vitmp(1,k) = 1;
      end;
    end;
end;

nobs = i;
new = 0;
j = 1;
while (new == 0 & j <= nobs)
if vsave(j,:) == vitmp(1,:)
visits(j,1) = visits(j,1) + 1;
new = 1;
end;
j = j+1;
end;

j = j-1;



function [vinew,vonew] = sample(vin,vout)
% PURPOSE: function used by bma_g to sample variables for changing model size
%          (called by bma_g.m, Bayesian model averaging)
% ----------------------------------------------------------
% USAGE: [vinew vonew] = sample(vin,vout)
% where:   vin  = a 1 x nvar1 vector of variable #'s for
%                 variables included in the model
%          vout = a 1 x nvar2 vector of variable #'s for
%                 variables excluded from the model
% ----------------------------------------------------------
% RETURNS: vinew = a 1 x nvar1+1 or 1 x nvar1-1 vector of
%                  variable #'s in the new model
%          vonew = a 1 x nvar2+1 or 1 x nvar2-1 vector of
%                  variable #'s excluded from the new model
% ----------------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jpl@jpl.econ.utoledo.edu

% decide on increase-decrease model size
coin = unif_rnd(1,0,1);
if coin > 0.5
increase = 0;
else
increase = 1;
end;

nv1 = length(vout); nv2 = length(vin);
nvar = nv1+nv2;

if nv1 == 0 % if all variables are in the model, we decrease
    increase = 1;
elseif nv2 == 0 % if all variables are out of the model, we increase
    increase = 0;
end;
    
if increase == 0 % increase model size
choose = round(unif_rnd(1,1,length(vout)));
vinew = [vin vout(choose)];
vonew = zeros(1,length(vout)-1);
cnt = 1;
for i=1:length(vout);
 if i~= choose
 vonew(cnt) = vout(i);
 cnt = cnt+1;
 end;
end;
else % decrease model size
choose = round(unif_rnd(1,1,length(vin)));
vinew = zeros(1,length(vin)-1);
vonew = zeros(1,length(vout)+1);
cnti = 1; cnto = 1;
for i=1:length(vin);
 if i~= choose
 vinew(cnti) = vin(i);
 cnti = cnti+1;
 else
 vonew = [vout vin(i)];
 end;
end;


end;




