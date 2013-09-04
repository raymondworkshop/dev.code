% find the pre-emphasis singal of S1
% get s1
N1= 0.6 * 48000;
N2= (0.6 + 0.02) * 48000;
[y]= wavread('x.wav',[N1 N2]);
s1=y(:,1);

a=0.935;

N= ceil(length(s1));
sig2(1,:) = s1(1,:);
for i=2:N    %choose a frame size as WINDOW
    sig2(i) = s1(i) - a * s1(i-1);
end
s2=sig2';
figure(5);
hold(); 
plot(N1/fs:1/fs:N2/fs,s1,'r');
plot(N1/fs:1/fs:N2/fs,s2,'g');
legend('S1','pem-S12',-1);
xlabel('time(s)');
ylabel('Amplitude');
title('S1 and pem-S12');
