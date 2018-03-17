function [avgVelocity] = avgVelocitySplit(graphPositions)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


loop1 = size(graphPositions,2)/2;
avgVelocity = [];


    for i =1:loop1
        
        totalDistance = 0;
        t=0;
        j=1;
        
        while t==0
        if (graphPositions(1,2*i-1)< -1000) && (graphPositions(1,2*i-1)> -4000) &&(graphPositions(1,2*i)< 3000) && (graphPositions(1,2*i-1)> -4000)
            
        xPos = graphPositions(j+1,2*i-1)- graphPositions(j,2*i-1);
        yPos = graphPositions(j+1,2*i)- graphPositions(j,2*i);        
        dist = sqrt(xPos^2+yPos^2);
        totalDistance = dist +totalDistance;
            
            if graphPositions(j+1,2*i-1)> 2000
                avgVelocity = [avgVelocity totalDistance/j];
                t=1;
            elseif graphPositions(j+1,2*i)> 3000
                avgVelocity = [avgVelocity NaN];
                t=1;
            elseif graphPositions(j+1,2*i)< -4000
                avgVelocity = [avgVelocity NaN];
                t=1;
             end
            
            if j ==2000
                t=1;
            end
             
        j = j+1;
        
        else
        avgVelocity = [avgVelocity NaN];    
        t=1;
        end
        
        end
      
    end
    
end
