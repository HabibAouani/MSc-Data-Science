% UCSD_GARCH Toolbox.
% Version 1.0       01-December-2000
%
% Help and Documentation
%   garchpq_demo          - A demo of the garchpq function
%   fattailed_garch_demo  - A demo of fatailed_garch
%
% Main Functions
%   garchpq                 - Univariate garch estimation with analytic derivatives
%   fattailed_garch         - Univariate GARCH estimation with normal, Students T and Generalized Error Distribution
%   multi_garch             - Univariate GARCH proceeedure to estimate a variety of GARCH specifications including AP GARCH
%   egarch                  - Exponential garch estimation with normal, Students T and Generalized Error Distribution
%
% Univariate GARCH Simulation
%   garchsimulate             - Sumilate Univariate GARCH series with normal innovations
%   fattailed_garchsimulate   - Simulate Univariate GARCH series with Normal, Students T, or GED innovations

%
% Likelihood Functions
%   garchlikelihood           - likelihood function called from garchpq
%   fattailed_garchlikelihood - likelihood function called from fattailed_garch
%   multi_garchlikelihood     - likelihood function called from multi_garch
%   egarchlikelihood          - likelihood function called from egarch
%
% Diagnostics
%   ljq2                      - Ljung-Box Q Test
%   lmtest1                   - Lagrange Multiplier Test for autocorrelation
%   lmtest2                   - Lagrange Multiplier Test for autocorrelation in the squarred residuals, an ARCH test
%   jarquebera                - Jarque-Bera test for normality
%   shapirowilks              - Shapiro-Wilks Test for normality
%   shapirofrancia            - Shapiro-Francia Test for normality
%   kolmogorov                - Kolmorogov-Shmirnov non-parametric test
%   berkowitz                 - The berkowitz transform of the KS test
%
% Helper Functions
%   fx.mat                    - a data set for foreign exchange return used by the demos
%   gedrnd                    - Generalized Error Distribution Random Number Generator
%   gedpdf                    - Generalized Error Distribution Probability Density Function
%   exppowrnd                 - Exponential Power Random number generator
%   exppowpdf                 - Exponential Power Random Probability Density Function
%   multi_garch_paramsetup    - helper function for multi_garch
%   multi_garch_constraints   - helper function for multi_garch
%   garchcore                 - helper function and MEX file for garchpq and fattailed_garch
%
% NOTE: This toolbox requires both matlab optimization toolbox and the excellent J.P.LeSage Library
%       available from www.spatial-econometrics.com
% 
% Copyright (c) 2000 Kevin Sheppard   All Rights Reserved.
