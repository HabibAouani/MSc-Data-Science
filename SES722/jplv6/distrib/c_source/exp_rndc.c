#include "mex.h"
#include "randomlib.h"


// exp_rndc.c 
// PURPOSE: returns exponential random deviates
// usage: out = exp_rndc(n,dof)
// where: n    = length of vector to return (scalar)
//        dof  = degrees of freedom parameter (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double dof;
  double *chi;
  int n;

  
  /* Check for proper number of arguments. */
  if(nrhs != 2) {
   mexErrMsgTxt("exp_rndc: 2 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("exp_rndc: 1 output argument");
  }
  
    n =  (int) mxGetScalar(prhs[0]); // an integer for number of draws

    dof = mxGetScalar(prhs[1]); // scalar degrees of freedom
    
    if (dof < 0.0){
       mexErrMsgTxt("exp_rndc: parameter < 0");
    }

    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    chi = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    exp_rndc(n,dof,chi);
  
}
