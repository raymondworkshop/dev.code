%calculate the number of different features found in the detection window
%in Viola-Jones' face detection algorithm

%
frameSize = 12;

num = 0;
% shape type 2x1
for x=1:frameSize
  for y=1:frameSize/2
     xblock=frameSize - x + 1;
     yblock=frameSize - y * 2 +1;
     num= xblock * yblock + num;
  end
end
disp(num);

type1=num;

num=0;
xblock=0;
yblock=0;
% shape type 2x3
for x=1:frameSize/3
    for y=1:frameSize/2
        xblock=frameSize - x * 3 + 1;
        yblock=frameSize - y * 2 + 1;
        num= xblock * yblock + num;
    end
end
disp(num);
type2=num;

num=0;
xblock=0;
yblock=0;
%shape type 2x2
for x=1:frameSize/2
  for y=1:frameSize/2
      xblock=frameSize - x *2 +1;
      yblock=frameSize -y * 2+1;
      num= xblock * yblock + num;
  end
end
disp(num);
type3=num;

count= type1 + type2 + type3;
disp(count);
