function [avgTotalDistance] = totDistance(graphPositions)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


loop1 = size(graphPositions,2)/2;
loop2 = size(graphPositions,1)-1;
totalDistance = 0;
avgTotalDistance = 0;

    for i =1:loop1
        
        for j = 1:loop2
            
             if graphPositions(j,2*i-1)> 3000
                graphPositions(j,2*i-1) = 3000;
            elseif graphPositions(j,2*i-1)< -4000
                graphPositions(j,2*i-1) = -4000;
            end
            
            if graphPositions(j+1,2*i-1)> 3000
                graphPositions(j+1,2*i-1) = 3000;
            elseif graphPositions(j+1,2*i-1)< -4000
                graphPositions(j+1,2*i-1) = -4000;
            end
            
             if graphPositions(j,2*i)> 3000
                 graphPositions(j,2*i) = 3000;
            elseif graphPositions(j,2*i)< -4000
                graphPositions(j,2*i)=-4000;
             end
            
             if graphPositions(j+1,2*i)> 3000
                 graphPositions(j+1,2*i) = 3000;
            elseif graphPositions(j+1,2*i)< -4000
                graphPositions(j+1,2*i) = -4000;
            end
            
        xPos = graphPositions(j+1,2*i-1)- graphPositions(j,2*i-1);
        yPos = graphPositions(j+1,2*i)- graphPositions(j,2*i);        
        dist = sqrt(xPos^2+yPos^2);
        totalDistance = dist +totalDistance;
        end
       
    end
    
   avgTotalDistance = totalDistance/loop1;
    
end

