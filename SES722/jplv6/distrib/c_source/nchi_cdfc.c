#include "mex.h"
#include "randomlib.h"


// nchi_cdfc.c 
// PURPOSE: returns cdf for non-central chi-squared deviates
// usage: cdf = nchi_cdfc(x,a,b)
// where: x    = x = prob[nchi(a,b) <= x], x = vector
//        a    = degrees of freedom parameter (scalar)
//        b    = degrees of freedom parameter (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
#define minlog 1.0E-37

  double a, b;
  double *x, *cdf;
  int n, i;
  
  /* Check for proper number of arguments. */
  if(nrhs != 3) {
    mexErrMsgTxt("nchi_cdfc: 3 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("nchi_cdfc: 1 output argument");
  }
  
    x = mxGetPr(prhs[0]);     // input vector
	n = mxGetM(prhs[0]);
    a = mxGetScalar(prhs[1]); // scalar degrees of freedom
    b = mxGetScalar(prhs[2]); // scalar degrees of freedom
    
	// error checking
    if((a < minlog || b < minlog)){
    mexErrMsgTxt("nchi_cdfc: a or b < 1e-37");
    }


    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    cdf = mxGetPr(plhs[0]);

    nchi_cdfc(n,a,b,x,cdf);
  
}
