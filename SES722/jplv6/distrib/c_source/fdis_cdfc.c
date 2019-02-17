#include "mex.h"
#include "randomlib.h"


// fdis_cdfc.c 
// PURPOSE: returns cdf for fdisa deviates
// usage: cdf = fdis_cdfc(x,a,b)
// where: x    = x = prob[fdis(a,b) <= x], x = vector
//        a    = numerator degrees of freedom parameter (scalar)
//        b    = denominator degrees of freedom parameter (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
#define minlog 1.0E-37

  double a, b;
  double *x, *cdf;
  int n, i;
  
  /* Check for proper number of arguments. */
  if(nrhs != 3) {
    mexErrMsgTxt("fdis_cdfc: 3 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("fdis_cdfc: 1 output argument");
  }
  
    x = mxGetPr(prhs[0]);     // input vector
	n = mxGetM(prhs[0]);
    a = mxGetScalar(prhs[1]); // scalar degrees of freedom
    b = mxGetScalar(prhs[2]); // scalar degrees of freedom
    
	// error checking
    if(a < minlog){
    mexErrMsgTxt("fdis_cdfc: a < 1e-37");
    }
   if(b < minlog){
    mexErrMsgTxt("fdis_cdfc: b < 1e-37");
    }


    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    cdf = mxGetPr(plhs[0]);
    
    fdis_cdfc(n,a,b,x,cdf);
  
}
