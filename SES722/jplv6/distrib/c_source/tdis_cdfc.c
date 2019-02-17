#include "mex.h"
#include "randomlib.h"


// tdis_cdfc.c 
// PURPOSE: returns cdf for t deviates
// usage: cdf = tdis_cdfc(x,a)
// where: x    = x = prob[tdis(a) <= x], x = vector
//        a    = degrees of freedom parameter (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
#define minlog 1.0E-37

  double a;
  double *x, *cdf;
  int n, i;
  
  /* Check for proper number of arguments. */
  if(nrhs != 2) {
    mexErrMsgTxt("tdis_cdfc: 2 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("tdis_cdfc: 1 output argument");
  }
  
    x = mxGetPr(prhs[0]);     // input vector
	n = mxGetM(prhs[0]);
    a = mxGetScalar(prhs[1]); // scalar degrees of freedom
    
	// error checking
    if(a < minlog){
    mexErrMsgTxt("tdis_cdfc: a < 1e-37");
    }


    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    cdf = mxGetPr(plhs[0]);
    
    tdis_cdfc(n,a,x,cdf);
  
}
