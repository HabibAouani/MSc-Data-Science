#include "mex.h"
#include "randomlib.h"



// pois_rnd.c 
// PURPOSE: returns poissioin random deviates
// usage: out = pois_rnd(n,mu)
// where: n    = length of vector to return (scalar)
//        mu   = mean

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
#define minlog 1.0E-37

  double a;
  double *beta;
  int n;

  
  /* Check for proper number of arguments. */
  if(nrhs != 2) {
    mexErrMsgTxt("pois_rnd: 2 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("pois_rnd: 1 output argument");
  }
  
    n =  (int) mxGetScalar(prhs[0]); // an integer for number of draws

    a = mxGetScalar(prhs[1]); // scalar degrees of freedom
    
    if((a < 0.0)){
    mexErrMsgTxt("pois_rnd: mean must be > 0");
    }

    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    beta = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    pois_rndc(n,a,beta);
  
}
