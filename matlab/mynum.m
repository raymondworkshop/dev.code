function [ num ] = mynum( s )
%   get the num
    num=0;
    lastSig = s(1);
    for i=2:length(s)
        currSig = s(i);
        if currSig*lastSig<0
            num = num+1;
        end
        lastSig = currSig;
    end
end