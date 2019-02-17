#include "mex.h"
#include "randomlib.h"



// nbino_rndc.c 
// PURPOSE: returns negative binomial random deviates
// usage: out = nbino_rndc(n,ntrials,prob)
// where: n       = length of vector to return (scalar)
//        ntrials = # of trails parameters
//        prob    = probability of success

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
#define minlog 1.0E-37

  double a, p;
  double *bino;
  int n;
  unsigned long ntrials;
  
  /* Check for proper number of arguments. */
  if(nrhs != 3) {
    mexErrMsgTxt("nbino_rndc: 3 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("nbino_rndc: 1 output argument");
  }
  
    n =  (int) mxGetScalar(prhs[0]); // an integer for number of draws

    a = mxGetScalar(prhs[1]); // scalar # of trials
    p = mxGetScalar(prhs[2]); // scalar prob of success

	ntrials = (long) a; // coerce it to long;
    
	// error checking
    if(a < minlog){
        mexErrMsgTxt("nbino_rndc: # of trials < 1e-37");
    }
	if ((p < 0) || (p > 1)){
		mexErrMsgTxt("nbino_rndc: 0 < prob < 1");
	}

    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,1, mxREAL);
    
    bino = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    nbino_rndc(n,ntrials,p,bino);
  
}
