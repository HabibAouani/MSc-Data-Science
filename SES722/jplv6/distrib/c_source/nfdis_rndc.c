#include "mex.h"
#include "randomlib.h"


// nfdis_rndc.c 
// PURPOSE: returns non-central F random deviates
// usage: out = nfdis_rndc(n,a,b,c)
// where: n    = length of vector to return (scalar)
//        a    = numerator degrees of freedom parameter (scalar)
//        b    = denominator degrees of freedom parameter (scalar)
//        c    = non-centrality parameter (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double a, b, c;
  double *nf;
  int n;

  
  /* Check for proper number of arguments. */
  if(nrhs != 4) {
    mexErrMsgTxt("nfdis_rnd: 4 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("nfdis_rnd: 1 output argument");
  }
  
    n =  (int) mxGetScalar(prhs[0]); // an integer for number of draws

    a = mxGetScalar(prhs[1]); // scalar degrees of freedom
    b = mxGetScalar(prhs[2]); // scalar degrees of freedom
    c = mxGetScalar(prhs[3]); // scalar degrees of freedom 
    
    if(a < 1.0 || b < 0.0){ 
      mexErrMsgTxt("nfdis_rnd: a must be > 1, and b > 0");
    }
    if (c < 0.0){
      mexErrMsgTxt("nfdis_rnd: non-centrality must be > 0");
    }
    
	
    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    nf = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    nfdis_rndc(n,a,b,c,nf);
  
}
