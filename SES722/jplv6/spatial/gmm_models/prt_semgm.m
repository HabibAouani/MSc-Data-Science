function prt_semgm(results,vnames,fid)
% PURPOSE: Prints output of SEMGMM1 and SEMGMM2
%---------------------------------------------------
% USAGE: prt_semgm(results,vnames,fid)
% Where: results = a structure returned by a spatial regression 
%        vnames  = an optional vector of variable names
%        fid     = optional file-id for printing results to a file
%                  (defaults to the MATLAB command window)
%--------------------------------------------------- 
%  NOTES: e.g. vnames = strvcat('y','const','x1','x2');
%         e.g. fid = fopen('ols.out','wr');
%  use prt_spat(results,[],fid) to print to a file with no vnames               
% --------------------------------------------------
%  RETURNS: nothing, just prints the spatial regression results
% --------------------------------------------------
% SEE ALSO: SEMGM1, SEMGM2
%---------------------------------------------------   

% written by: Shawn Bucholtz
% SBUCHOLTZ@ers.usda.gov
% USDA-ERS-ISD-ADB
% adopted from code written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jpl@jpl.econ.utoledo.edu

if ~isstruct(results)
 error('prt_SEMGM requires structure argument');
elseif nargin == 1
 nflag = 0; fid = 1;
elseif nargin == 2
 fid = 1; nflag = 1;
elseif nargin == 3
 nflag = 0;
 [vsize junk] = size(vnames); % user may supply a blank argument
   if vsize > 0
   nflag = 1;          
   end;
else
 error('Wrong # of arguments to prt_SEMGM');
end;

nvar = results.nvar;
nobs = results.nobs;

% handling of vnames
Vname = 'Variable';
 for i=1:nvar
    tmp = ['variable ',num2str(i)];
    Vname = strvcat(Vname,tmp);
 end;
if strcmp(results.meth,'semgm1');
% add spatial parameter name
    Vname = strvcat(Vname,'lambda');
elseif strcmp(results.meth,'semgm2');
    Vname = strvcat(Vname,'lambda1');
    Vname = strvcat(Vname,'lambda2');
end;

if (nflag == 1) % the user supplied variable names
[tst_n nsize] = size(vnames);
 if tst_n ~= nvar+1
 fprintf(fid,'Wrong # of variable names in prt_SEMGM -- check vnames argument \n');
 fprintf(fid,'will use generic variable names \n');
 nflag = 0;
 else,
Vname = 'Variable';
 for i=1:nvar
    Vname = strvcat(Vname,vnames(i+1,:));
 end;
% add spatial rho parameter name
if strcmp(results.meth,'semgm1');
% add spatial parameter name
    Vname = strvcat(Vname,'lambda');
elseif strcmp(results.meth,'semgm2');
    Vname = strvcat(Vname,'lambda1');
    Vname = strvcat(Vname,'lambda2');
end;
end; % end of if-else
end; % end of nflag issue

switch results.meth

case {'semgm1'} % <=================== GMM spatial error model one weight matrix


nobs = results.nobs;
nvar = results.nvar;

fprintf(fid,'\n');
if size(results.lambda) == 1;
    fprintf(fid,'Generalized Moments Estimation of Spatial Error Model with 1 weight matrix \n');
else;
    fprintf(fid,'Generalized Moments Estimation of Spatial Error Model with 2 weight matrices \n');
end;
if (nflag == 1)
fprintf(fid,'Dependent Variable     = %16s \n',vnames(1,:));
end;
% fprintf(fid,'Lambda #1          = %9.4f   \n',results.lambda(1));
% fprintf(fid,'Lambda #1 t-stat   = %9.4f   \n',results.lambdatstat(1));
% fprintf(fid,'Lambda #2          = %9.4f   \n',results.lambda(2));
% fprintf(fid,'Lambda #2 t-stat   = %9.4f   \n',results.lambdatstat(2));
fprintf(fid,'GM sigma^2         = %9.4f   \n',results.GMsige);
%end;
fprintf(fid,'R-squared          = %9.4f   \n',results.rsqr);
fprintf(fid,'Rbar-squared       = %9.4f   \n',results.rbar);
fprintf(fid,'sigma^2            = %9.4f   \n',results.sige);
fprintf(fid,'Nobs, Nvars        = %6d,%6d \n',results.nobs,results.nvar);
fprintf(fid,'optimization time  = %9.4f   \n',results.time1);
fprintf(fid,'total time         = %9.4f   \n',results.time2);


fprintf(fid,'***************************************************************\n');

bout = [results.beta
        results.lambda];
        
tstats = [results.tstat
          results.lambdatstat];

% now print coefficient estimates, t-statistics and probabilities
tout = norm_prb(tstats); % find asymptotic z (normal) probabilities
tmp = [bout tstats tout];  % matrix to be printed
% column labels for printing results
bstring = 'Coefficient'; tstring = 't-stat'; pstring = 'probability';
cnames = strvcat(bstring,tstring,pstring);
in.cnames = cnames;
in.rnames = Vname;
in.fmt = '%16.6f';
in.fid = fid;
mprint(tmp,in);


case {'semgm2'} % <=================== GMM spatial error model two weight matrices


nobs = results.nobs;
nvar = results.nvar;

fprintf(fid,'\n');
if size(results.lambda) == 1;
    fprintf(fid,'Generalized Moments Estimation of Spatial Error Model with 1 weight matrix \n');
else;
    fprintf(fid,'Generalized Moments Estimation of Spatial Error Model with 2 weight matrices \n');
end;
if (nflag == 1)
fprintf(fid,'Dependent Variable     = %16s \n',vnames(1,:));
end;
% fprintf(fid,'Lambda #1          = %9.4f   \n',results.lambda(1));
% fprintf(fid,'Lambda #1 t-stat   = %9.4f   \n',results.lambdatstat(1));
% fprintf(fid,'Lambda #2          = %9.4f   \n',results.lambda(2));
% fprintf(fid,'Lambda #2 t-stat   = %9.4f   \n',results.lambdatstat(2));
fprintf(fid,'GM sigma^2         = %9.4f   \n',results.GMsige);
%end;
fprintf(fid,'R-squared          = %9.4f   \n',results.rsqr);
fprintf(fid,'Rbar-squared       = %9.4f   \n',results.rbar);
fprintf(fid,'sigma^2            = %9.4f   \n',results.sige);
fprintf(fid,'Nobs, Nvars        = %6d,%6d \n',results.nobs,results.nvar);
fprintf(fid,'optimization time  = %9.4f   \n',results.time1);
fprintf(fid,'total time         = %9.4f   \n',results.time2);


fprintf(fid,'***************************************************************\n');

bout = [results.beta
        results.lambda];
        
tstats = [results.tstat
          results.lambdatstat];

% now print coefficient estimates, t-statistics and probabilities
tout = norm_prb(tstats); % find asymptotic z (normal) probabilities
tmp = [bout tstats tout];  % matrix to be printed
% column labels for printing results
bstring = 'Coefficient'; tstring = 't-stat'; pstring = 'probability';
cnames = strvcat(bstring,tstring,pstring);
in.cnames = cnames;
in.rnames = Vname;
in.fmt = '%16.6f';
in.fid = fid;
mprint(tmp,in);

otherwise
error('results structure not known by prt_semgm function');
end;
