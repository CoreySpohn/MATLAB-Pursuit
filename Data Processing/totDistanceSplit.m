function [totalSplit] = totDistanceSplit(graphPositions)
%Finds the total distance travelled for each person


loop1 = size(graphPositions,2)/2;
loop2 = size(graphPositions,1)-1;
totalSplit = zeros(1,size(graphPositions,2)/2);
    
    %loop through all participants
    for i =1:loop1
        
        totalDistance = 0;
        
        %loops through all data points
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
        
        %calculates distance travelled between two steps for a person    
        xPos = graphPositions(j+1,2*i-1)- graphPositions(j,2*i-1);
        yPos = graphPositions(j+1,2*i)- graphPositions(j,2*i);        
        dist = sqrt(xPos^2+yPos^2);
        totalDistance = dist +totalDistance;
        end
       totalSplit(1,i) = totalDistance;
    end
    
end

