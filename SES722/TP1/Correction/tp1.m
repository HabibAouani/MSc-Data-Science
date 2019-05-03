
load crime1.raw

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              %
%  Criminality and income       %        
%                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% histogram of income (y)

f=figure;
hist(crime1(:,9))
title('Distribution of income')
xlabel('Income')
ylabel('Frequency')

% histogram of number of arrests (x)

f=figure;
hist(crime1(:,1))
title('Distribution of number of arrests')
xlabel('Number of arrests')
ylabel('Frequency')

% mean, variance, correlation between x and y

disp('mean ')
mean(crime1(:,1:13))'

disp('variance')
std(crime1(:,1:13))'

disp('min')
min(crime1)'

disp('max')
max(crime1)'

disp('covariance')
cov(crime1(:,1:13))' 

disp('correlation')
corrcoef(crime1(:,1:13))'

% cloud of points (x,y)

f=figure;
scatter(crime1(:,1),crime1(:,9))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           %
%  Comparison of salary Men/Women     %        
%                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load wage1.raw

% average salary


disp('average salary for both genders')
mean(wage1(:,1))'


% for women
s=(wage1(:,6)==1); % indicator for female variable

disp('number of women')
sum(s) % number of women in a database

disp('average salary for women')
mean(wage1(s,1))'
f=figure;
hist(wage1(s,1))
title('Distribution of salary for women')
xlabel('Salary')
ylabel('Frequency')

%for men

t=(wage1(:,6)==0); % indicator for men variable 

disp('number of men')
sum(t)

disp('average salary for men')
mean(wage1(t,1))'

f=figure;
hist(wage1(t,1))
title('Distribution of salary for men')
xlabel('Salary')
ylabel('Frequency')

%  descriptive statistics for other variables for each gender

wage1f=wage1(s,:) ; % the database including only women 
wage1m=wage1(t,:) ; % the database including only men

disp(' average of the explanatory variables associated with women ')
mean(wage1f)

disp('average of the explanatory variables associated with men')
mean(wage1m)


% transformation of variables

dum=1*(wage1(:,6)==0) +2*(wage1(:,6)==1);

truc=wage1(:,2)-1; 

bidule=log(wage1(:,1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           %
%  Comparison of salary Men/Women     %        
%                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load ceosal1.raw

% test de student

y=ceosal1(:,1);
[n,k]=size(ceosal1) 
X=[ones(n,1),ceosal1(:,4)]; 
[n,k]=size(X)

% estimation of parameters

beta=inv(X'*X)*X'*y

% ecarts-types

u=y-X*beta
sig2=u'*u/(n-4) 
std_dv=sqrt(diag(sig2*inv(X'*X)))

% distribution of residuals

f=figure;
hist(u)
title('Distribution of residuals')
xlabel('Residuals')
ylabel('Frequency')

% estimation of parameters after log transformation 
logy=log(y)
beta=inv(X'*X)*X'*logy
u=logy-X*beta

f=figure;
hist(u)
title('Distribution of residuals after log transformation')
xlabel('Residuals')
ylabel('Frequency')


% multiplication of y by 1000

y1=1000*ceosal1(:,1)
beta1=inv(X'*X)*X'*y1 %beta1=1000*beta


% multiplication of explanatory variable by 1000

X1=X
X1(:,2)=1000*X1(:,2)
beta2=inv(X1'*X1)*X1'*y1 

% outliers

I = find(u>=2.5) ;
s=(u<=2.5);
sum(s) ;
X=X(s,:); 
logy=logy(s,:);
beta=inv(X'*X)*X'*logy
