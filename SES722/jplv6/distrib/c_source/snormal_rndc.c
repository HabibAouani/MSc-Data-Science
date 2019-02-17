#include "mex.h"
#include "randomlib.h"


// snormal_rndc.c 
// PURPOSE: returns standardized normal random deviates
// usage: out = snormal_rndc(n)
// where: n    = length of vector to return (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double *chi;
  int  n;

  
  /* Check for proper number of arguments. */
  if(nrhs != 1) {
    flag = 0;
    mexErrMsgTxt("snormal_rndc: 1 input required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("snormal_rndc: 1 output argument");
  }
  
    n =  (int) mxGetScalar(prhs[0]); // an integer for number of draws

    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    chi = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    snormal_rndc(n,chi);
  
}
