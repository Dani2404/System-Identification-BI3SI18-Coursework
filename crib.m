% A skeleton for a recursive identification algorithm. Since the assignment
% assumes an ARX model this code does likewise.
% You need to set Na, Nb (number of a and b coefficients) and LN (large 
% number).  Nc is not needed if this is an ARX model. You also need to supply
% the algorithm!
% The code assumes that the data is in a vector y and the input is in a vector u

theta_nminus1=zeros(Na+Nb,1); % Initialise the estimate of theta to zero
P_nminus1=LN.*eye(Na+Nb);	 % Initialise P where LN is a large number
% Theta=[]; % history of theta starts here
% Step through data and for each new point generate a new estimate
for n=1:10 % Change 10 to length(y) once you have the code working
% set py to the previous Na y values
  py=zeros(1,Na);
  for i=n-1:-1:n-Na
    if i>0 py(n-i)=y(i);   end
  end
% set pu to the previous Nb u values
  pu=zeros(1,Nb);q
  for i=n-1:-1:n-Nb
    if i>0 pu(n-i)=u(i);   end
  end
% Construct varphi from py' and pu'
% varphi= ...
% Use varphi(n), y(n) theta(n-1) and P(n-1) to iterate the next estimate
% epsilon= ...
% P= P_nminus1 - ...
% K= ...
% theta=theta_nminus1 + ...
% get ready for the new iteration
  theta_nminus1=theta;
  P_nminus1=P;
% To get a history of theta set Theta=[Theta; theta']
end % and so it ends
% If you have recorded parameter evolution you can plot with
% plot(Theta)