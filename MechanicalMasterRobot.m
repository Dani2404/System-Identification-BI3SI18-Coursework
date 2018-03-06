% A skeleton for a recursive identification algorithm. Since the assignment
% assumes an ARX model this code does likewise.
% You need to set Na, Nb (number of a and b coefficients) and LN (large 
% number).  Nc is not needed if this is an ARX model. You also need to supply
% the algorithm!
% The code assumes that the data is in a vector y and the input is in a vector u

%CHANGE THESE VALUES FOR PART B -> Na =2 and Nb=2 is set for the first
%model

%HOW TO USE:
%Step 1: Clear Variables
% Step 2: Run loadass2.m to get new data for theta and y
% step 3: set Na and Nb to the correct number of variables
% step 4: assign variables a1, a2.... to theta(1), theta(2)...
% step 5: run for new graphs

Na = 2;%number of Y values 
Nb = 2;%number of u values
LN = 10000000;

u=60*ones(size(y)); %Step Input

%LoadAss2
%get variables a and b from matrix theta 
a1 = theta(1);
a2 = theta(2);
b1 = theta(3);
b2 = theta(4);

num = [0 a1 a2]
den = [1 b1 b2]


theta_nminus1=zeros(Na+Nb,1); % Initialise the estimate of theta to zero --> Matrix of zeros
P_nminus1=LN.*eye(Na+Nb);	 % Initialise P where LN is a large number --> Data 
Lambda = 1; %Initalise lambda, set to 1 for non-forgetting 
Theta=[]; % history of theta starts here
% Step through data and for each new point generate a new estimate
for n=1:length(y) % Change 10 to length(y) once you have the code working
% set py to the previous Na y values
  py=zeros(1,Na);
  for i=n-1:-1:n-Na
    if i>0 py(n-i)=y(i);   end
  end
% set pu to the previous Nb u values
  pu=zeros(1,Nb);
  for i=n-1:-1:n-Nb
    if i>0 pu(n-i)=u(i);   end
  end
% Construct varphi from py' and pu'
varphi=[-py';pu']; %Combining py and pu
% Use varphi(n), y(n) theta(n-1) and P(n-1) to iterate the next estimate
epsilon = y(n) - varphi' * theta_nminus1;
P = (1/Lambda)* (P_nminus1 - ((P_nminus1* varphi* varphi'* P_nminus1)/(Lambda + varphi'* P_nminus1* varphi)));
K =  P * varphi; 
theta = theta_nminus1 + K*epsilon;
% get ready for the new iteration
  theta_nminus1=theta;
  P_nminus1=P;
  %Plots theta and its estimate of the next value
  Theta=[Theta; theta'];
  estimateValue = theta'
end % and so it ends

yfit = filter([0 theta(3) theta(4)], [1 theta(1) theta(2)], u);


figure('Name', 'Parameter Evolution ')
plot(Theta)
title('Theta vs Time')
xlabel('time(t)')
ylabel('\theta')

%Plot the input and estimate on same graph to compare
figure('Name', 'Actual Output vs estimated Ouput')
hold on;
plot(yfit);
plot(y)
legend('Output Estimate', 'Actual Output') 
hold off
title('Actual Output vs estimated Ouput')
xlabel('time(t)')
ylabel('y(t)')

figure('Name', 'Pole-Zero Map')
pzmap(1, den)
hold on;
axis([-1.5, 1.5, -1.5, 1.5])
i = 1:101;plot(cos(i*pi*2/100), sin(i*pi*2/100))
