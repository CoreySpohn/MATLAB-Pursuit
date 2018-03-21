function [avg] = avgDistance(graphPositions)
%finds the total distance at each time between all participants and
%averages

loop0 = size(graphPositions,1);
loop1 = size(graphPositions,2)/2-1;
loop2 = size(graphPositions,2)/2;
total = 0;
count = 0;

for k = 1:loop0
    
    for i =1:loop1
   
        for j = i+1:loop2
            
            %if the data point is outside the boundaries in the experiment
            %then this replaces the data point with the boundary
            if graphPositions(k,2*i-1)> 3000
                graphPositions(k,2*i-1) = 3000;
            elseif graphPositions(k,2*i-1)< -4000
                graphPositions(k,2*i-1) = -4000;
            end
            
            if graphPositions(k,2*j-1)> 3000
                graphPositions(k,2*j-1) = 3000;
            elseif graphPositions(k,2*j-1)< -4000
                graphPositions(k,2*j-1) = -4000;
            end
            
             if graphPositions(k,2*i)> 3000
                 graphPositions(k,2*i) = 3000;
            elseif graphPositions(k,2*i)< -4000
                graphPositions(k,2*i)=-4000;
             end
            
             if graphPositions(k,2*j)> 3000
                 graphPositions(k,2*j) = 3000;
            elseif graphPositions(k,2*j)< -4000
                graphPositions(k,2*j) = -4000;
             end
        
        %calculates the distance between all people at each time in the experiment    
        xPos = graphPositions(k,2*i-1)- graphPositions(k,2*j-1);
        yPos = graphPositions(k,2*i)- graphPositions(k,2*j);
        dist = sqrt(xPos^2+yPos^2);
            
        total = total + dist;
        count = count +1;
        end
    
    end

end
%averages the total distance    
avg=total/count;

end

