% Load data

% AR(1)
y = zeros(1000,1);
for i=2:2000
    y(i) = 0.6 * y(i-1) + randn;
end
plot(y)
acf = sacf(y,20)
pacf = spacf(y,20)

% AR(2)
n=1000; 
y=zeros(n,1);
for i=3:1000;
    y(i)=0.6*y(i-1)+0.2*y(i-2)+randn;
end;
plot(y)
acf=sacf(y,20);
pacf=spacf(y,20);

% MA(1)
n=1000; z=zeros(n,1)
e=randn(n,1);
for i=2:1000;
    z(i)=e(i)+0.8*e(i-1);
end;
plot(z);
acf=sacf(z,20)
pacf=spacf(z,20)

% ARMA(2,2)
for i=3:1000;
    y(i)=0.5*y(i-1)-0.8*y(i-2)+e(i)+0.6*e(i-1)+0.2*e(i-2);
end;
plot(y)
acf=sacf(y,20)
pacf=spacf(y,20)


