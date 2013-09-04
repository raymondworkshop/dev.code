% find the 8 LPC constants from autocorrelation methods

% get s1
N1= 0.6 * 48000;
N2= (0.6 + 0.02) * 48000;
[y]= wavread('x.wav',[N1 N2]);
s1=y(:,1);
p=8;

N= length(s1);
for i=1:9
    autocoeff(i) = 0;
    for j=i:N
        autocoeff(i) = autocoeff(i) + s1(j)*s1(j-i+1);
    end
end

x=autocoeff(1:end -1);
x1=toeplitz(x);
x2=inv(x1);
r=autocoeff(2:9);
a=x1*r';

