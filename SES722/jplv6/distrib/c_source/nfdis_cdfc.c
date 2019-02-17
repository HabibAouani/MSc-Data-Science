#include "mex.h"
#include "randomlib.h"


// nfdis_cdfc.c 
// PURPOSE: returns cdf for non-central F deviates
// usage: cdf = nfdis_cdfc(x,a,b,c)
// where: x    = x = prob[nfdis(a,b,c) <= x], x = vector
//        a    = degrees of freedom parameter (scalar)
//        b    = degrees of freedom parameter (scalar)
//        c    = non-centrality parameter (scalar)

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
#define minlog 1.0E-37

  double a, b, c;
  double *x, *cdf;
  int n;
  
  /* Check for proper number of arguments. */
  if(nrhs != 4) {
    mexErrMsgTxt("nfdis_cdfc: 4 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("nfdis_cdfc: 1 output argument");
  }
  
    x = mxGetPr(prhs[0]);     // input vector
	n = mxGetM(prhs[0]);
    a = mxGetScalar(prhs[1]); // scalar degrees of freedom
    b = mxGetScalar(prhs[2]); // scalar degrees of freedom
    c = mxGetScalar(prhs[3]); // scalar degrees of freedom
   
	// error checking
    if((a < minlog || b < minlog)){
    mexErrMsgTxt("nfdis_cdfc: a or b < 1e-37");
    }

    if((c < minlog)){
    mexErrMsgTxt("nfdis_cdfc: c < 1e-37");
    }

    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    cdf = mxGetPr(plhs[0]);

    nfdis_cdfc(n,a,b,c,x,cdf);
  
}
