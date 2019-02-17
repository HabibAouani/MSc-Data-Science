% timing test for c-language Randlib versions vs. matlab versions

% results for an Anthalon 1200 Mhz with 512 Meg of DDR memory
% 1,000,000 random deviates generated

% Distribution      c-mex     matlab 
% beta             6.0890   255.5770 
% bino             0.3700   110.4290 
% chi              1.8720     5.0170 
% F                1.3120   157.2460 
% gamma            0.5310    53.3360 
% poisson          0.5510    13.0690 
% student-t        1.0510     4.2660 

% New functions added are:
%
% nchi_rndc, nchi_cdfc,   non-central chi-squared
% nfdis_rndc, nfdis_cdfc, non-central F
% nbino_rndc, nbino_cdfc, negative binomial


info.rnames = strvcat('Distribution', ...
'beta','bino','chi','F','gamma','poisson','student-t');
info.cnames = strvcat('c-mex','matlab');

ndistrib = length(info.rnames)-1;

times = zeros(7,2);

n = 1000000;

a = 5;
b = 10;
c = 1;

% beta distribution
timet = clock;
out = beta_rndc(n,a,b);
times(1,1) = etime(clock,timet);

timet = clock;
out = beta_rnd(n,a,b);
times(1,2) = etime(clock,timet);

mprint(times(1,:));

% binomial distribution
ntrials = 10;
prob = 0.5;
timet = clock;
out = bino_rndc(n,ntrials,prob);
times(2,1) = etime(clock,timet);

timet = clock;
out = bino_rnd(ntrials,prob,n,1);
times(2,2) = etime(clock,timet);

mprint(times(2,:));

% chi-squared distribution
timet = clock;
out = chis_rndc(n,a);
times(3,1) = etime(clock,timet);

timet = clock;
out = chis_rnd(n,a);
times(3,2) = etime(clock,timet);

mprint(times(3,:));

% F-distribution
timet = clock;
out = fdis_rndc(n,a,b);
times(4,1) = etime(clock,timet);

timet = clock;
out = fdis_rnd(n,a,b);
times(4,2) = etime(clock,timet);

mprint(times(4,:));

% gamma-distribution
timet = clock;
out = gamm_rndc(n,a,b);
times(5,1) = etime(clock,timet);

timet = clock;
out = gamm_rnd(n,a,b);
times(5,2) = etime(clock,timet);

mprint(times(5,:));

% poisson-distribution
timet = clock;
out = pois_rndc(n,a);
times(6,1) = etime(clock,timet);

timet = clock;
out = pois_rnd(n,a);
times(6,2) = etime(clock,timet);

mprint(times(6,:));

% t-distribution
timet = clock;
out = tdis_rndc(n,a);
times(7,1) = etime(clock,timet);

timet = clock;
out = tdis_rnd(n,a);
times(7,2) = etime(clock,timet);

mprint(times(7,:));


mprint(times,info);

