% load x.wav
%fileName='C:\Users\zhaoxl\Downloads\homework\assignment3\x.wav';
[y,fs,nbits]=wavread('x.wav'); 
sound(y,fs);
time =(1:length(y))/fs;
plot(time,y);
ylabel('y'); 
xlabel('time/s');
title('speech channel');
fprintf('Duration = %g seconds\n', length(y)/fs);
fprintf('Sampling rate = %g samples/second\n', fs);
fprintf('Bit resolution = %g bits/sample \n', nbits);

