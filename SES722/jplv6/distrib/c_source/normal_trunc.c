#include "mex.h"
#include "randomlib.h"
#include "matrixjpl.h"


// normal_trunc.c 
// PURPOSE: returns truncated normal random deviates
// usage: out = normal_trunc(mu,sig,left,right)
// where: mu = mean
//        sig = variance
//        left = left truncation point
//        right = right truncation point

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double *left, *mu, *sig, *right, *out;
  int n, i,j;
  
  /* Check for proper number of arguments. */
  if(nrhs != 4) {
    mexErrMsgTxt("normal_trunc: 4 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("normal_trunc: 1 output argument");
  }
    
    mu = mxGetPr(prhs[0]); // mean vector
    n =  mxGetM(prhs[0]);  // an integer for size of vector
	sig = mxGetPr(prhs[1]);
	left = mxGetPr(prhs[2]);
	right = mxGetPr(prhs[3]);
	
    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    out = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    normal_truncc(n,mu,sig,left,right,out);

  
}
