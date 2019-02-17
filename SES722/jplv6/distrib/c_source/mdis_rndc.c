#include "mex.h"
#include "randomlib.h"



// mdis_rndc.c 
// PURPOSE: returns multinomial random deviates
// usage: out = mdis_rndc(n,nevents,ncat,prob)
// where: n       = length of vector to return (scalar)
//        nevents = # of events to be classified
//        ncat    = # of categories, a scalar
//        prob    = probabilities,   k x 1 vector sum(prob) = 1

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
#define minlog 1.0E-37

  double **mult;
  int i, n, np, nevents;
  double ncat, psum, *p, nevt;
  unsigned long ntrials;
  
  /* Check for proper number of arguments. */
  if(nrhs != 4) {
    mexErrMsgTxt("mdis_rndc: 3 inputs required.");
  }
  if(nlhs!=1) {
    mexErrMsgTxt("mdis_rndc: 1 output argument");
  }
  
    n =  (int) mxGetScalar(prhs[0]); // an integer for number of draws

    nevt = mxGetScalar(prhs[1]); // scalar # of trials

    ncat = mxGetScalar(prhs[2]); // scalar # of trials
	p = mxGetPr(prhs[3]);     // input vector
	np = mxGetM(prhs[3]);     // length of input vector
	
	mexPrintf("np = %d \n",np);
 
	nevents = (int) nevt; 
	ntrials = (long) ncat; // coerce it to long;
    
	// error checking
    if(ncat < minlog){
        mexErrMsgTxt("mdis_rndc: # of trials < 1e-37");
    }
	// check that p sums to unity
	psum = 0.0;
	for (i=0; i<np; i++){
	mexPrintf(" p = %lf \n",p[i]);
		psum = psum + p[i];
		}

	//if (psum != 1.0){
    //    mexErrMsgTxt("mdis_rndc: probs must sum to unity");
	//}

	for (i=0; i<np; i++){
	if ((p[i] < 0) || (p[i] > 1)){
		mexErrMsgTxt("mdis_rndc: 0 < prob < 1");
	}
	}

 /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(n,np, mxREAL);
  
   
    mult = mxGetPr(plhs[0]);
   
    /* Call the  subroutine. */
    mdis_rndc(n,nevents,ntrials,p,mult);
  
}
