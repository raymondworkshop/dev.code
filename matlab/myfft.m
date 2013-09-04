% get the samples from 0.6s to (0.6 + 0.02) s
fs = 48000 ;
%[y,fs,nbits]=wavread('x.wav'); 
N1= 0.6 * 48000;
N2= (0.6 + 0.02) * 48000;

[y]= wavread('x.wav',[N1 N2]);
figure(3);
plot(N1/fs:1/fs:N2/fs,y);

xlabel('time(s)');
ylabel('Amplitude');
title('Segment S1');

% number of signal elements in time domain
s1=y(:,1);
N= ceil(length(s1));
%for i=1:N
  for m=1:N/2+1
      xreal(m)=0;
      ximg(m)=0;
   % s1real = s1(0);  % when k =0
    for k=1:N-1
        theta= -2*pi*k*m/N;
        
        xreal(m) = xreal(m) +s1(k)* cos(theta);
        ximg(m)  = ximg(m) + s1(k)* sin(theta);
        
    end
    
   sm(m)  = sqrt(xreal(m).^2 + ximg(m).^2);  
  end
  energy =sm';
%end
%magnitude= sm';
figure(4);
plot((fs/length(s1):(fs/length(s1)):(fs/length(s1)*(length(s1)/2+1))),energy);
%xlabel('frequence');
ylabel('energy');
title('fourier transform for S1');
grid on;
grid monior;
