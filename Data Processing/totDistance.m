function [avgTotalDistance] = totDistance(graphPositions)
%Finds total distance travelled for each person and averages

%
loop1 = size(graphPositions,2)/2;
loop2 = size(graphPositions,1)-1;
totalDistance = 0;
avgTotalDistance = 0;

    %loop through all participants
    for i =1:loop1
        
        %loop through all data points
        for j = 1:loop2
            
            %if the data point is outside the boundaries in the experiment
            %then this replaces the data point with the boundary
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
        
        %calculates the distance between a participants j and j+1 step     
        xPos = graphPositions(j+1,2*i-1)- graphPositions(j,2*i-1);
        yPos = graphPositions(j+1,2*i)- graphPositions(j,2*i);        
        dist = sqrt(xPos^2+yPos^2);
        totalDistance = dist +totalDistance;
        end
       
    end
    
   avgTotalDistance = totalDistance/loop1;
    
end

