#include "mex.h"
#include "randomlib.h"

// nchi_rndc.c 
// PURPOSE: returns non-central chisquared random deviates
// usage: out = nchi_rndc(n,a,b)
// where: n    = length of vector to return (scalar)
//        a    = degrees of freedom parameter (scalar)
//        b    = non-centrality parameter (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double a, b;
  double *nchi;
  int n;
 

  
  /* Check for proper number of arguments. */
  if(nrhs != 3) {
    mexErrMsgTxt("nchi_rndc: 3 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("nchi_rndc: 1 output argument");
  }
  
    n =  (int) mxGetScalar(prhs[0]); // an integer for number of draws

    a = mxGetScalar(prhs[1]); // scalar degrees of freedom
    b = mxGetScalar(prhs[2]); // scalar degrees of freedom
    
    if(a < 1.0 || b < 0.0){ 
      mexErrMsgTxt("nchi_rndc: a must be > 1, and b > 0");
    }

    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    nchi = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    nchi_rndc(n,a,b,nchi);
  
}
