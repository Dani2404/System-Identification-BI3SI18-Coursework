% A skeleton for a recursive identification algorithm. Since the assignment
% assumes an ARX model this code does likewise.
% You need to set Na, Nb (number of a and b coefficients) and LN (large 
% number).  Nc is not needed if this is an ARX model. You also need to supply
% the algorithm!
% The code assumes that the data is in a vector y and the input is in a vector u
Na = 2;%number of Y values
Nb = 2;%number of u values
LN = 10000000;
%[B,A] = dord2;
%num = B;
%den = A;
num = [0 0.0416 0.0395];
den = [1 -1.5363 0.8607];
u = 5 * sin(1:.2:70);
noise = 0.01*randn(size(u)); %Change the varience in order to change nouse level, overall noise model should be 0 mean.
%noise =0.1*rand(size(u)); %Use rand as varience not set to 1, 
y = filter(num, den, u) + noise;

theta_nminus1=zeros(Na+Nb,1); % Initialise the estimate of theta to zero --> Matrix of zeros
P_nminus1=LN.*eye(Na+Nb);	 % Initialise P where LN is a large number --> Data 
%Lambda = 1; %Initalise lambda, set to 1 for non-forgetting
Lambda = 0.95 %Initaluse lambda set to 0.95 for forgetting
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
P = P_nminus1 - ((P_nminus1* varphi* varphi'* P_nminus1)/(Lambda + varphi'* P_nminus1* varphi));
K =  P * varphi; 
theta = theta_nminus1 + K*epsilon;
% get ready for the new iteration
  theta_nminus1=theta;
  P_nminus1=P;
  Theta=[Theta; theta']
end % and so it ends
% If you have recorded parameter evolution you can plot with

%Geterate the estimate model output
yfit = filter([0 theta(3) theta(4)], [1 theta(1) theta(2)], u);

%hold on;
figure('Name', 'Parameter Evolution ')
plot(Theta)
title('Theta vs Time')
xlabel('time(t)')
ylabel('\theta')
%title('

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

