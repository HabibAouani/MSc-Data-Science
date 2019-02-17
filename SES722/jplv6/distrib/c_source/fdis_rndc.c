#include "mex.h"
#include "randomlib.h"


// fdis_rndc.c 
// PURPOSE: returns f-ratio random deviates
// usage: out = fdis_rndc(n,a,b)
// where: n    = length of vector to return (scalar)
//        a    = numerator degrees of freedom parameter (scalar)
//        b    = denominator degrees of freedom parameter (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double a, b;
  double *fdis;
  int  n;
 
  /* Check for proper number of arguments. */
  if(nrhs != 3) {
    mexErrMsgTxt("fdis_rndc: 3 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("fdis_rndc: 1 output argument");
  }
  
    n =  (int) mxGetScalar(prhs[0]); // an integer for number of draws

    a = mxGetScalar(prhs[1]); // scalar degrees of freedom
    b = mxGetScalar(prhs[2]); // scalar degrees of freedom
    
    if(a <= 0.0 || b <= 0.0) {
      mexErrMsgTxt("fdis_rndc: dof < 0");
    }

 
    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    fdis = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    fdis_rndc(n,a,b,fdis);
  
}
