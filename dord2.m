function [a,b,c,d] = dord2(wn, z,T)
%       [num,den]=dord2(wn,z,T) - see assignment
%       Generate second order system sampled at T and with natural
%       frequency Wn and damping factor Z.
%       [A,B,C,D] = dord2(Wn, Z) returns the A,B,C,D representation of the
%       sampled second order system.
%       For a demo run dord without return arguments.
 
%error(nargchk(2,2,nargin));

if nargin < 3;T=.3;end
if nargin < 2;z=rand;end
if nargin < 1;wn=.5+2*rand;end


if nargout==4,          % Generate state space system
  [a,b,c,d]=ord2(wn,z);
else
  [a,b,c,d]=ord2(wn,z);
  [Phi,Gam]=c2d(a,b,T);
  [a,b]=ss2tf(Phi,Gam,c,d);
  if nargout == 0 
    num=a;den=b;
    y=filter(num,den,ones(size(1:150)));
    plot(y)
  end
end