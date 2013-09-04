% find the pitch of S1
% get s1
N1= 0.6 * 48000;
N2= (0.6 + 0.02) * 48000;
[y]= wavread('x.wav',[N1 N2]);
s1=y(:,1)';

N= ceil(length(s1));

[a b] = size(s1);
autocorrx=zeros(size(s1));
for m=1:b
    
    for n=1:b-m+1
       autocorrx(m)=autocorrx(m)+ s1(n)*s1(n+m-1);
    end
end
figure(6);
plot(autocorrx);
ylabel('x(n)');
grid on;
grid monior;
