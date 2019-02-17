#include "mex.h"
#include "randomlib.h"


// bino_cdfc.c 
// PURPOSE: returns cdf for binomial deviates
// usage: cdf = bino_cdfc(x,ntrials,prob)
// where: x    = x = prob[bino(ntrials,prob) <= x], x = vector
//     ntrials = # of trials (scalar)
//      prob   = probability of success (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
#define minlog 1.0E-37

  double a, p;
  double *x, *cdf;
  int n;
  
  /* Check for proper number of arguments. */
  if(nrhs != 3) {
    mexErrMsgTxt("bino_cdfc: 3 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("bino_cdfc: 1 output argument");
  }
  
    x = mxGetPr(prhs[0]);     // input vector
	n = mxGetM(prhs[0]);
    a = mxGetScalar(prhs[1]); // scalar # of trials
    p = mxGetScalar(prhs[2]); // scalar prob of success
        
	// error checking
    if(a < minlog){
        mexErrMsgTxt("bino_rndc: # of trials < 1e-37");
    }
	if ((p < 0) || (p > 1)){
		mexErrMsgTxt("bino_rndc: 0 < prob < 1");
	}

    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    cdf = mxGetPr(plhs[0]);

    bino_cdfc(n,a,p,x,cdf);
  
}
