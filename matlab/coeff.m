% find the 8 LPC constants from autocorrelation methods

% get s1
x=[3 4 9 5 6 1 3 6 8];

N= length(x);
for i=1:3
    autocoeff(i) = 0;
    for j=i:N
        autocoeff(i) = autocoeff(i) + x(j)*x(j-i+1);
    end
end

s=autocoeff(1:end -1);
s1=toeplitz(s);
s2=inv(s1);
r=autocoeff(2:3);
a=s1*r';

