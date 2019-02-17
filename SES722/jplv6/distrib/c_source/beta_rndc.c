#include "mex.h"
#include "randomlib.h"



// beta_rnd.c 
// PURPOSE: returns beta random deviates
// usage: out = beta_rndc(n,a,b)
// where: n    = length of vector to return (scalar)
//        a    = degrees of freedom parameter (scalar)
//        b    = degrees of freedom parameter (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
#define minlog 1.0E-37

  double a, b;
  double *beta;
  int n;
  
  /* Check for proper number of arguments. */
  if(nrhs != 3) {
    mexErrMsgTxt("beta_rndc: 3 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("beta_rndc: 1 output argument");
  }
  
    n =  (int) mxGetScalar(prhs[0]); // an integer for number of draws

    a = mxGetScalar(prhs[1]); // scalar degrees of freedom
    b = mxGetScalar(prhs[2]); // scalar degrees of freedom
    
	// error checking
    if((a < minlog || b < minlog)){
    mexErrMsgTxt("beta_rndc: a or b < 1e-37");
    }

    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    beta = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    beta_rndc(n,a,b,beta);
  
}
