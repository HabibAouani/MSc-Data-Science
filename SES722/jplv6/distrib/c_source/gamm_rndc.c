#include "mex.h"
#include "randomlib.h"


// gamm_rndc.c 
// PURPOSE: returns gamma random deviates
// usage: out = gamm_rndc(n,a,b)
// where: n    = length of vector to return (scalar)
//        a    = degrees of freedom parameter (scalar)
//        b    = degrees of freedom parameter (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double a, b;
  double *gamm;
  int n;
 
  /* Check for proper number of arguments. */
  if(nrhs != 3) {
    mexErrMsgTxt("gamm_rndc: 3 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("gamm_rndc: 1 output argument");
  }
  
    n =  (int) mxGetScalar(prhs[0]); // an integer for number of draws

    a = mxGetScalar(prhs[1]); // scalar degrees of freedom
    b = mxGetScalar(prhs[2]); // scalar degrees of freedom
    
    if(a <= 0.0 && b <= 0.0) {
      mexErrMsgTxt("gamm_rndc: a,b parameters negative or zero");
    }

    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    gamm = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    gamm_rndc(n,a,b,gamm);
  
}
