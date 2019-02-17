/* Change this to reflect the apropriate header file */
#include "c:\matlabr12\extern\include\mex.h"
#include <math.h> 

/*
* garchcore.c - 
* This is a helper function and is part of the UCSD_GARCH toolbox 
* You can compile it and should work on any platform.
* 
* Author: Kevin Sheppard
* kksheppard@ucsd.edu
* Revision: 1    Date: 3/28/2001
*/
/* $ Revision: 1.10 $ */
void makeh(double *ht, double *data, double *parameters, int p, int q, int m, int T, double *Ht)
{
	int i, j,count=m;
	for (j=0; j<m; j++) {
		*(Ht+j)=*(ht+j);
	}
	for (i=0; i<(T-m); i++) {
		*(Ht+count)=parameters[0];
		for (j=0; j<p; j++) {
			*(Ht+count)=*(Ht+count)+parameters[j+1]* pow(*(data+(count-(j+1))),2);
		}
        for (j=0; j<q; j++) {
			*(Ht+count)=*(Ht+count)+parameters[j+p+1]* *(Ht+(count-(j+1)));
		}
        count++;
	}
}


/* The gateway routine */
void mexFunction( int nlhs, mxArray *plhs[],
				 int nrhs, const mxArray *prhs[])
{
	double *ht,*data, *parameters, *Ht;
	int p, q, m, T;
	int     mrows,ncols;
	
	/*  Check for proper number of arguments. */
	/* NOTE: You do not need an else statement when using
	mexErrMsgTxt within an if statement. It will never
	get to the else statement if mexErrMsgTxt is executed.
	(mexErrMsgTxt breaks you out of the MEX-file.) 
	*/
	if(nrhs!=7) 
		mexErrMsgTxt("Seven inputs required.");
	if(nlhs!=1) 
		mexErrMsgTxt("One output required.");
	
	/*  Get the scalar inputs */
	p = mxGetScalar(prhs[3]);
	q = mxGetScalar(prhs[4]);
	m = mxGetScalar(prhs[5]);
	T = mxGetScalar(prhs[6]);
    
	/*  Create a pointer to the input matrices . */
	ht         = mxGetPr(prhs[0]);
	data       = mxGetPr(prhs[1]);
	parameters = mxGetPr(prhs[2]);
	
	/*  Get the dimensions of the matrix input ht to make an output matrix. */
	mrows = mxGetM(prhs[0]);
	ncols = mxGetN(prhs[0]);
	
	/*  Set the output pointer to the output matrix. */
	plhs[0] = mxCreateDoubleMatrix(mrows,ncols, mxREAL);
	
	/*  Create a C pointer to a copy of the output matrix. */
	Ht = mxGetPr(plhs[0]);
	
	/*  Call the C subroutine. */
	makeh(ht,data,parameters,p, q, m, T, Ht);
	
}