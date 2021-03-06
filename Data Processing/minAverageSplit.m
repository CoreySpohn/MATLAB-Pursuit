function [trialAverage] = minAverageSplit(graphPositions)
%finds the average minimum distance for each participant in the experiment

loop0 = size(graphPositions,2)/2;
loop1 = size(graphPositions,1);
loop2 = size(graphPositions,2)/2;
countTotal = 0;
avgTotal = 0;
trialAvg = zeros(1,size(graphPositions,2)/2);

%loop through all participants
for k = 1:loop0
    
    total =0;
    count =0;
    
    %loop through all data points
    for i =1:loop1
   
        min = 10000000000;
        
        for j = 1:loop2
            
            %if the data point is outside the boundaries in the experiment
            %then this replaces the data point with the boundary
             if graphPositions(i,2*k-1)> 3000
                graphPositions(i,2*k-1) = 3000;
            elseif graphPositions(i,2*k-1)< -4000
                graphPositions(i,2*k-1) = -4000;
            end
            
            if graphPositions(i,2*j-1)> 3000
                graphPositions(i,2*j-1) = 3000;
            elseif graphPositions(i,2*j-1)< -4000
                graphPositions(i,2*j-1) = -4000;
            end
            
             if graphPositions(i,2*k)> 3000
                 graphPositions(i,2*k) = 3000;
            elseif graphPositions(i,2*k)< -4000
                graphPositions(i,2*k)=-4000;
             end
            
             if graphPositions(i,2*j)> 3000
                 graphPositions(i,2*j) = 3000;
            elseif graphPositions(i,2*j)< -4000
                graphPositions(i,2*j) = -4000;
             end
        
        %calculates the distance between each participant    
        xPos = graphPositions(i,2*k-1)- graphPositions(i,2*j-1);
        yPos = graphPositions(i,2*k)- graphPositions(i,2*j);        
        dist = sqrt(xPos^2+yPos^2);
        
            if dist > 0 
                if dist < min
                    min = dist;
                end
            end
        
        end
        
        total = total + min;
        count = count +1;
        
    end
    
    avg=total/count;
    trialAverage(1,k) = avg;
    avgTotal = avg +avgTotal;
    countTotal = countTotal +1;
end
    
minAverage=avgTotal/countTotal;

end

