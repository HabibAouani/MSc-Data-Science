/* Change this to reflect the apropriate header file */
#include "c:\matlabr12\extern\include\mex.h"
#include <math.h> 

/*
* armaxcore.c - 
* This is a helper function and is part of the UCSD_GARCH toolbox 
* You can compile it and should work on any platform.
* 
* Author: Kevin Sheppard
* kksheppard@ucsd.edu
* Revision: 1    Date: 3/28/2001
*/
/* $ Revision: 1.00 $ */
void armaxcore(double *e, double*y, double *yhat, double *parameters, int ar, int ma, int T, double *errors)
{
	int i, j,count=ma;
	for (j=0; j<ma; j++) {
		*(errors+j)=0;
	}
	for (i=0; i<(T-ma); i++) {
		*(errors+count)=*(y+count)-*(yhat+count);
    for (j=0; j<ma; j++) {
			*(errors+count)=*(errors+count)-parameters[j+ar]* *(errors+(count-(j+1)));
		}
        count++;
	}
}


/* The gateway routine */
void mexFunction( int nlhs, mxArray *plhs[],
				 int nrhs, const mxArray *prhs[])
{
	double *e,*yhat, *y, *parameters, *errors;
	int ma, T, ar;
	int mrows,ncols;
	
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
	ar = mxGetScalar(prhs[4]);
	ma = mxGetScalar(prhs[5]);
	T  = mxGetScalar(prhs[6]);
	
    
	/*  Create a pointer to the input matrices . */
	e          = mxGetPr(prhs[0]);
	yhat       = mxGetPr(prhs[1]);
	y          = mxGetPr(prhs[2]);
	parameters = mxGetPr(prhs[3]);
	
	/*  Get the dimensions of the matrix input ht to make an output matrix. */
	mrows = mxGetM(prhs[0]);
	ncols = mxGetN(prhs[0]);
	
	/*  Set the output pointer to the output matrix. */
	plhs[0] = mxCreateDoubleMatrix(mrows,ncols, mxREAL);
	
	/*  Create a C pointer to a copy of the output matrix. */
	errors = mxGetPr(plhs[0]);
	
	/*  Call the C subroutine. */
	armaxcore(e,y,yhat, parameters, ar, ma, T, errors);
	
}