#include "mex.h"
#include "randomlib.h"
#include "matrixjpl.h"


// normal_rndc.c 
// PURPOSE: returns multivariate normal random deviates
// usage: out = normal_rndc(vcov)
// where: vcov = variance-covariance matrix

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double *vcov, *out, **vcovmat;
  int n, i,j;

  /* Check for proper number of arguments. */
  if(nrhs != 1) {
    mexErrMsgTxt("normal_rndc: 1 input matrix required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("normal_rndc: 1 output argument");
  }
    
    vcov = mxGetPr(prhs[0]); // var-cov matrix
    n =  (int) mxGetScalar(prhs[1]); // an integer for size of vcov

	vcovmat = dmatrix(0,n-1,0,n-1);

	// put vcov into vcovmat
    // #define X(i,j) x[i + j*n]

    for(i=0; i<n; i++){
        for(j=0; j<n; j++)
            vcovmat[i][j] = vcov[i + j*n];
    }
	
    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    out = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    normal_rndc(vcovmat,n,out);

	free_dmatrix(vcovmat,0,n-1,0);
  
}
