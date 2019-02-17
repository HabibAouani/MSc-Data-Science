% Distributions library -- Jim LeSage 
%
%   
%         beta_cdf : cdf of the beta distribution
%        beta_cdfc : cdf of the beta distribution (cmex version)
%           beta_d : demo of beta distribution functions
%         beta_inv : inverse of the cdf (quantile) of the beta(a,b) distribution
%         beta_pdf : pdf of the beta(a,b) distribution
%         beta_rnd : random draws from the beta(a,b) distribution
%        beta_rndc : random draws from the beta(a,b) distribution (cmex version)
%          bincoef : generate binomial coefficients
%           bingen : generate binomial probability
%         bino_cdf : cdf at x of the binomial(n,p) distribution
%        bino_cdfc : cdf at x of the binomial(n,p) distribution (cmex version)
%           bino_d : demo of binomial distribution functions
%         bino_pdf : pdf at x of the binomial(n,p) distribution
%         bino_rnd : random sampling from a binomial distribution
%        bino_rndc : random sampling from a binomial distribution (cmex version)
%         chis_cdf : returns the cdf at x of the chisquared(n) distribution
%        chis_cdfc : cdf of the chi-squared distribution (cmex version)
%           chis_d : demo of chis-squared distribution functions
%         chis_inv : returns the inverse (quantile) at x of the chisq(n) distribution
%         chis_pdf : returns the pdf at x of the chisquared(n) distribution
%         chis_prb : computes the chi-squared probability function
%         chis_rnd : generates random chi-squared deviates
%        chis_rndc : generates random chi-squared deviates (cmex version)
%         com_size : makes a,b scalars equal to constant matrices size(x)
%         exp_rndc : random draws from the exp(mean) distribution (cmex version)
%         fdis_cdf : returns cdf at x of the F(a,b) distribution
%        fdis_cdfc : returns cdf at x of the F(a,b) distribution (cmex version)
%           fdis_d : demo of F-distribution functions
%         fdis_inv : returns inverse (quantile) at x of the F(a,b) distribution
%         fdis_pdf : returns pdf at x of the F(a,b) distribution
%         fdis_prb : computes f-distribution probabilities
%         fdis_rnd : returns random draws from the F(a,b) distribution
%        fdis_rndc : returns random draws from the F(a,b) distribution (cmex version)
%         gamm_cdf : returns the cdf at x of the gamma(a) distribution
%        gamm_cdfc : returns the cdf at x of the gamma(a) distribution (cmex version)
%           gamm_d : demo of gamma distribution functions
%         gamm_inv : returns the inverse of the cdf at p of the gamma(a) distribution
%         gamm_pdf : returns the pdf at x of the gamma(a) distribution
%         gamm_rnd : a matrix of random draws from the gamma distribution
%        gamm_rndc : a vector of random draws from the gamma distribution (cmex version)
%         hypg_cdf : hypergeometric cdf function
%           hypg_d : demo of Hypergeometric distribution functions
%         hypg_inv : hypergeometric inverse (quantile) function
%         hypg_pdf : hypergeometric pdf function
%         hypg_rnd : hypergeometric random draws
%        is_scalar : determines if argument x is scalar
%         logn_cdf : cdf of the lognormal distribution
%           logn_d : demo of log-normal distribution functions
%         logn_inv : inverse cdf (quantile) of the lognormal distribution
%         logn_pdf : pdf of the lognormal distribution
%         logn_rnd : random draws from the lognormal distribution
%         logt_cdf : cdf of the logistic distribution
%           logt_d : demo of logistic distribution functions
%         logt_inv : inv of the logistic distribution
%         logt_pdf : pdf of the logistic distribution at x
%         logt_rnd : random draws from the logistic distribution
%        make_html : makes HTML verion of contents.m files for the Econometrics Toolbox
%       nbino_cdfc : cdf at x of the negative binomial(n,p) distribution (cmex version)
%       nbino_rndc : random sampling from a negative binomial distribution (cmex version)
%        nchi_cdfc : cdf of the non-central chi-squared distribution (cmex version)
%        nchi_rndc : random deviates from the non-central chi-squared distribution (cmex version)
%       nfdis_cdfc : cdf of the non-central F distribution (cmex version)
%       nfdis_rndc : random deviates from the non-central F distribution (cmex version)
%         norm_cdf : computes the cumulative normal distribution 
%        norm_crnd : random numbers from a contaminated normal distribution
%         norm_inv : computes the quantile (inverse of the CDF) 
%         norm_pdf : computes the normal probability density function 
%         norm_prb : computes normal probability given
%        norm_prbd : demo of norm_prb function
%         norm_rnd : random multivariate random vector based on
%     norm_rndtime test for norm_rnd
%          normc_d : demo of contaminated normal random numbers
%         normlt_d : demo of left-truncated normal random numbers
%       normlt_inv : compute inverse of cdf for left-truncated normal
%       normlt_rnd : compute random draws from a left-truncated normal
%      normlt_rndc : CMEX to compute random draws from a left-truncated normal
%         normrt_d : demo of right-truncated normal random numbers
%       normrt_inv : compute inverse of cdf for right-truncated normal
%       normrt_rnd : compute random draws from a right-truncated normal
%      normrt_rndc : CMEX to compute random draws from a right-truncated normal
%          normt_d : demo of truncated normal random numbers
%        normt_inv : compute inverse of cdf for truncated normal
%        normt_rnd : random draws from a normal truncated to (left,right) interval
%       normt_rndc : CMEX random draws from a normal truncated to (left,right) interval
%         pois_cdf : computes the cumulative distribution function at x
%        pois_cdfc : computes the cdf at x of the Poisson distribution (cmex version)
%           pois_d : demo of poisson distribution functions
%         pois_inv : computes the quantile (inverse of the cdf) at x
%         pois_pdf : computes the probability density function at x
%         pois_rnd : generate random draws from the possion distribution
%        pois_rndc : generate random draws from the possion distribution (cmex version)
%         quantile : compute empirical quantile (percentile).
%         stdn_cdf : computes the standard normal cumulative
%           stdn_d : demo of standard normal distribution functions
%         stdn_inv : computes the quantile (inverse of the CDF) 
%         stdn_pdf : computes the standard normal probability density
%         tdis_cdf : returns cdf at x of the t(n) distribution
%        tdis_cdfc : returns cdf at x of the t(n) distribution (cmex version)
%           tdis_d : demo of Student t-distribution functions
%         tdis_inv : returns the inverse (quantile) at x of the t(n) distribution
%         tdis_pdf : returns the pdf at x of the t(n) distribution
%         tdis_prb : calculates t-probabilities for elements in x-vector 
%         tdis_rnd : returns random draws from the t(n) distribution
%        tdis_rndc : returns random draws from the t(n) distribution (cmex version)
%      timing_test test for c-language Randlib versions vs. matlab versions
%          trunc_d : demo of truncated normal draws
%           unif_d : demo of uniform distribution functions
%         unif_rnd : returns a uniform random number between a,b 
%           wish_d : demo of random draws from a Wishart distribution
%         wish_rnd : generate random wishart matrix
