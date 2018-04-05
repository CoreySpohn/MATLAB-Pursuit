%Calculates the average time for each participant in the experiment

function [avgTime] = avgTimeSplit(graphPositions)

%loop through every robot/person
loop1 = size(graphPositions,2)/2;
avgTime = [];


    %loop through all data points
    for i =1:loop1
        
        j=0;
        
        for p = 1:size(graphPositions,1)
        %The participant has to start in the start area which is -3000<x<-1000 and -4000<y<3000, finds the first time crossing into the play area    
        if (graphPositions(p,2*i-1)< 3000) && (graphPositions(p,2*i-1)> -3000) &&(graphPositions(p,2*i)< 3000) && (graphPositions(p,2*i-1)> -4000)
            j=p;
            break
        end
        end
        
        totalDistance = 0;
        t=0;
        
        %Using a while loop to start counting the persons velocity when they start the experiment in the designated start area and stop counting the participants velocity
        %after they cross the finish line
        while t==0
        
        if j==0
           avgTime = [avgTime NaN];
           break
        end
        
        %Finding the difference between two consecutive data points for a participant    
        xPos = graphPositions(j+1,2*i-1)- graphPositions(j,2*i-1);
        yPos = graphPositions(j+1,2*i)- graphPositions(j,2*i);        
        dist = sqrt(xPos^2+yPos^2);
        totalDistance = dist +totalDistance;
            
            %exiting the loop if the participant reaches the finish line at
            %2000, or the person goes out of bounds in y direction y>4000
            %or y <-3000, j-p is the end timestep minus the first timestep
            %in the play area
            if graphPositions(j+1,2*i-1)> 3000
                avgTime = [avgTime (j+1-p)];
                t=1;
            elseif graphPositions(j+1,2*i)> 3000
                avgTime = [avgTime (j+1-p)];
                t=1;
            elseif graphPositions(j+1,2*i)< -4000
                avgTime = [avgTime (j+1-p)];
                t=1;
            elseif graphPositions(j+1,2*i-1)< -3000
                avgTime = [avgTime (j+1-p)];
                t=1;
            %exiting the loop if the person is still in the play area at end of trial 
            elseif j ==size(graphPositions,1)-1
                avgTime = [avgTime (j+1-p)];
                t=1;
            end
             
        j = j+1;
        
        end

    end
    
end

