% % A skeleton for a recursive identification algorithm. Since the assignment
% assumes an ARX model this code does likewise.
% You need to set Na, Nb (number of a and b coefficients) and LN (large
% number).  Nc is not needed if this is an ARX model. You also need to supply
% the algorithm!
% The code assumes that the data is in a vector y and the input is in a vector u
t = 1:236;
[m,n] = size(t);
LN = 100;
Na = 2; % number of coefficients for the y values/a values
Nb = 2; % number of cofficients for the u values/b values
lambda = 0.5;
num = [0 0.0416 0.0395]; % set to B --> theta(2) theta(3)
den = [1 -1.5363 0.8607]; % set to A -->

% set input to step input u=ones(1,50)
% set input to sine wave u=5*sin(1:.2:70)
% set input to random input u=0.5*randn(1,2d
filename = 'DataSetOneExchangeRateGDP-EURO(1).xls';
sheet = 1;
datarange = 'B98:B333';
u = xlsread(filename, sheet, datarange);
noise =0.01*randn(size(u));% Gaussian noise
%digital filter slides across data and gives an average of data in that
%window 
% e.g. windowSize = 5; 
% b = (1/windowSize)*ones(1,windowSize);
% a = 1;
%filter(a, b, data)
y = filter(num, den, u); 
y1 = y + noise;
y2 = zeros(m,n);


% theta_nminus1=zeros(Na+Nb,1); % Initialise the estimate of theta to zero
% C_nminus1=LN.*eye(Na+Nb);  % Initialise P where LN is a large number --> data 
% % L_nminus1=LN*eye(Na+Nb);

theta_nminus1=zeros(Na+Nb,1); % Initialise the estimate of theta to zero
P_nminus1=LN.*eye(Na+Nb);  % Initialise P where LN is a large number --> data 

Theta=[]; % history of theta starts here
% Step through data and for each new point generate a new estimate
for n=1:length(y1) % Change 10 to length(y) once you have the code working
% set py to the previous Na y values
  py=zeros(1,Na);
  for i=n-1:-1:n-Na
    if i>0 
        py(n-i)=y1(i);   
    end
  end
% set pu to the previous Nb u values
  pu=zeros(1,Nb);
  for i=n-1:-1:n-Nb
    if i>0 
        pu(n-i)=u(i);   
    end
  end
  % For simple moving average: Y(n) = (X(n-1) + X(n) +X(n+1)) / 3
  % Loop from 2:n-1 to validate the real meaning of (n-1) and (n+1)
  for i = 2:(n-1)
    y2(i) = (y1(i-1) + y1(i) + y1(i+1))/3;
  end

  
% Construct varphi from py? and pu'
% Use varphi(n), y(n) theta(n-1) and P(n-1) to iterate the next estimate
  varphi= [-py'; pu'];
  epsilon= y(n) - varphi'* theta_nminus1; 
  P = 1/lambda*( P_nminus1 - ((P_nminus1 * (varphi * varphi')* P_nminus1)/(lambda + varphi' * P_nminus1 * varphi)));
  K = P * varphi;
  theta = theta_nminus1 +  K * epsilon;
  
% get ready for the new iteration
  theta_nminus1=theta;
  P_nminus1=P;
% To get a history of theta set Theta=[Theta; theta?]
  Theta =[Theta; theta'];
end 

x = linspace(1998, 2016, 236);
% Recorded parameter evolution you can plot with
figure(1);
plot(Theta);
title('Parameter Evolution');
xlabel('t'); ylabel('\theta(t)');
shg;

% Generate the estimate model output
% theta at postition 1 -> a1 etc
% yfit=filter([num],[den])
yfit=filter([0 theta(3) theta(4)],[1 theta(1) theta(2)],u);
figure(2);
% Plots actual output vs estimate output
plot(y);
hold on;
plot(y2);
legend('Actual Output','Estimated Output')
title('Actual Output vs Estimated Output');
xlabel('t');ylabel('y(t)');
hold off;
shg;

figure(3)
subplot(311);
plot(x, y1); title('noise added signal');
xlabel('date'); ylabel('GDP-Euro Exchange Rate');
subplot(312);
plot(x,y2); title('smoothed signal');
xlabel('date'); ylabel('Moving Average');
subplot(313);
plot(x,yfit); title('estimated signal');xlabel('date'); ylabel('GDP-Euro Exchange Rate');
xlabel('date'); ylabel('GDP-Euro Exchange Rate');

figure(4);
% Plots actual output vs estimate output
plot(u);
hold on;
plot(y);
hold off;
shg;
