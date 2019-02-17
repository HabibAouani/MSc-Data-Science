function [sumA, sumB, startingvalues, LB, UB]=multi_garch_constraints(garchtype, startingvalues, sumA, sumB, p, q, data, type)
% PURPOSE: constraints for multigarch
[lambda, nu, b, c, garchtype]=multi_garch_paramsetup(type);
LB=[];
UB=[];
TolCon=2*1e-6;    
CTolCon = 0.02;

% Now to build the parameter restrictions and starting values;
if garchtype==1
   % Do Nothing   
elseif garchtype==2
   % Need to add a C starting val and restriction
   sumA=[sumA';zeros(1,2+p+q)]';
   Cconst=zeros(2,size(sumA,2));
   Cconst(1,size(sumA,2))=1;
   Cconst(2,size(sumA,2))=-1;
   sumA=[sumA;Cconst];
   sumB=[sumB;1-CTolCon;1-CTolCon];
   startingvalues=[startingvalues;c];   
elseif garchtype==3
   % Need to add a B and C starting value and restrictions;
   sumA=[sumA';zeros(2,2+p+q)]';
   Bconst=zeros(2,size(sumA,2));
   Bconst(1,size(sumA,2)-1)=1;
   Bconst(2,size(sumA,2)-1)=-1;   
   Bconst1=quantile(data,.8);
   Bconst2=(quantile(data,.3)>0)*quantile(data,.2)+(quantile(data,.3)<0)*(-1)*quantile(data,.3);
   Cconst=zeros(2,size(sumA,2));
   Cconst(1,size(sumA,2))=1;
   Cconst(2,size(sumA,2))=-1;   
   sumA=[sumA;Bconst;Cconst];
   sumB=[sumB;Bconst1;Bconst2;1-CTolCon;1-CTolCon];
   startingvalues=[startingvalues;b;c];   
elseif garchtype==4
   % Need to add lambda starting values and restrictions
   sumA=[sumA';zeros(1,2+p+q)]';
   
   lambdaconst=zeros(1,size(sumA,2));
   lambdaconst(size(sumA,2))=-1;
   sumA=[sumA;lambdaconst];
   sumB=[sumB;.1];
   startingvalues=[startingvalues;lambda];   
elseif garchtype==5
   % Need to add a B starting val and restriction
   sumA=[sumA';zeros(1,2+p+q)]';
   startingvalues=[startingvalues;b];
elseif garchtype==6
   % Need to add lambda and c starting values and restrictions
   sumA=[sumA';zeros(2,2+p+q)]';
   
   lambdaconst=zeros(1,size(sumA,2));
   lambdaconst(size(sumA,2)-1)=-1;
   sumA=[sumA;lambdaconst];
   sumB=[sumB;.1];
   
   Cconst=zeros(2,size(sumA,2));
   Cconst(1,size(sumA,2))=1;
   Cconst(2,size(sumA,2))=-1;
   sumA=[sumA;Cconst];
   sumB=[sumB;1-CTolCon;1-CTolCon];
   startingvalues=[startingvalues;lambda;c];
elseif garchtype==7
   % Need to add lambda and b and c starting values and restrictions
   sumA=[sumA';zeros(3,2+p+q)]';
   
   lambdaconst=zeros(1,size(sumA,2));
   lambdaconst(size(sumA,2)-2)=-1;
   sumA=[sumA;lambdaconst];
   sumB=[sumB;.1];
   
   Cconst=zeros(2,size(sumA,2));
   Cconst(1,size(sumA,2))=1;
   Cconst(2,size(sumA,2))=-1;
   sumA=[sumA;Cconst];
   sumB=[sumB;1-CTolCon;1-CTolCon];
   startingvalues=[startingvalues;lambda;b;c];
end
