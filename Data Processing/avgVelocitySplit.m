function [avgVelocity] = avgVelocitySplit(graphPositions)
%Calculates the average velocity for each participant in the experiment

loop1 = size(graphPositions,2)/2;
avgVelocity = [];

    %loop through all data points
    for i =1:loop1
        
        totalDistance = 0;
        t=0;
        j=1;
        
        %Using a while loop to start counting the persons velocity when they start the experiment in the designated start area and stop counting the participants velocity
        %after they cross the finish line
        while t==0
            
        %The participant has to start in the start area which is -4000<x<-1000 and -4000<y<3000    
        if (graphPositions(1,2*i-1)< -1000) && (graphPositions(1,2*i-1)> -4000) &&(graphPositions(1,2*i)< 3000) && (graphPositions(1,2*i-1)> -4000)
        
        %Finding the difference between two consecutive data points for a participant    
        xPos = graphPositions(j+1,2*i-1)- graphPositions(j,2*i-1);
        yPos = graphPositions(j+1,2*i)- graphPositions(j,2*i);        
        dist = sqrt(xPos^2+yPos^2);
        totalDistance = dist +totalDistance;
            
            %exiting the loop if the participant reaches the finish line at
            %2000, or the person goes out of bounds in y direction y>4000
            %or y <-3000
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
            
            %exiting the loop if the person is still in the play area after 2000 data points 
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

