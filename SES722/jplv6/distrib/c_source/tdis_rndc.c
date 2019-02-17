#include "mex.h"
#include "randomlib.h"


// tdis_rndc.c 
// PURPOSE: returns t random deviates
// usage: out = tdis_rndc(n,dof)
// where: n    = length of vector to return (scalar)
//        dof  = degrees of freedom parameter (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
#define minlog 1.0E-37
  double dof;
  double *chi;
  int n;
  
  /* Check for proper number of arguments. */
  if(nrhs != 2) {
    mexErrMsgTxt("tdis_rndc: 2 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("tdis_rndc: 1 output argument");
  }
  
    n =  (int) mxGetScalar(prhs[0]); // an integer for number of draws

    dof = mxGetScalar(prhs[1]); // scalar degrees of freedom
    if (dof < minlog){
       mexErrMsgTxt("tdis_rndc: dof < 1e-37");
    }

    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    chi = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    tdis_rndc(n,dof,chi);
  
}
