% find the start T1 and stop T2 locations in time (ms) of the first digit
 
% total time is 2s and every frame size is 20ms
% thus, we can get the loop times
%k = 2 / 0.02;
[y,fs,nbits]=wavread('x.wav'); 

% set frame size 20ms, separated by 10ms
 n = 0.02 * fs; 
 m = 0.01 * fs; 

 %define the threshold of energy
 energy = y.^2;
 energyMean = mean(energy(:,1));
 energyVar = var(energy(:,1));
 energyThreshold = n * (energyMean - energyVar);
 
 % 
 beginNum = 0; endNum = 0;
 % flag
 flag = 0;
 % define a constant 
 zeroNum = ceil(n/100);
 
% local function
 
 for i=1:m:length(y)
   
   if flag == 0
        % if the energy level and zero-crossing rate of 3 successive frames is
        % high, then it is the starting point
       if mynum(y(i:i+n))>= zeroNum && sum(energy(i:i+n)) >= energyThreshold
          if mynum(y(i+n:i+n+n))>= zeroNum && sum(energy(i+n:i+n+n)) >= energyThreshold
             if mynum(y(i+2*n:i+3*n))>=zeroNum && sum(energy(i+2*n:i+3*n))>=energyThreshold
               
                 beginNum = i;
                 flag = 1;
               
             end
          end
          
       end
       
   else
   % and if the energy and zero-crosssing rate for 5 successive frames are 
   % lower than 0.1,then it is the end point 
   if mynum(y(i:i+n))>=zeroNum && sum(energy(i:i+n))<=energyThreshold
      if mynum(y(i+n:i+n+n))>=zeroNum && sum(energy(i+n:i+n+n))<=energyThreshold
          if mynum(y(i+2*n:i+2*n+n))>=zeroNum && sum(energy(i+2*n:i+2*n+n))<=energyThreshold
          
              if mynum(y(i+3*n:i+3*n+n))>=zeroNum && sum(energy(i+3*n:i+3*n+n))<=energyThreshold
               
                  if mynum(y(i+4*n:i+4*n+n))>=zeroNum && sum(energy(i+4*n:i+4*n+n))<=energyThreshold
                      endNum = i;
                  end
              end
         end
      end
   end
   
   % if we get the two, break
  if beginNum~=0 && endNum~=0
    break;
  end
   
   end 
 end  
figure(2);
plot(beginNum/fs:1/fs:endNum/fs,y(beginNum:endNum));
xlabel('time(s)');
ylabel('S1');
title('The first digit');
 