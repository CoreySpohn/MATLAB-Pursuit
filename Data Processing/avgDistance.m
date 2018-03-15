function [avg] = avgDistance(graphPositions)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

loop0 = size(graphPositions,1);
loop1 = size(graphPositions,2)/2-1;
loop2 = size(graphPositions,2)/2;
total = 0;
count = 0;

for k = 1:loop0
    
    for i =1:loop1
   
        for j = i+1:loop2
        xPos = graphPositions(k,2*i-1)- graphPositions(k,2*j-1);
        yPos = graphPositions(k,2*i)- graphPositions(k,2*j);
        dist = sqrt(xPos^2+yPos^2);
        total = total + dist;
        count = count +1;
        end
    
    end

end
    
avg=total/count;

end

