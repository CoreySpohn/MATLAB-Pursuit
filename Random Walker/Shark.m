classdef Shark < handle
    %SHARK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position
        velocity
        speed
        range
        historicalPosition
        direction
        xLimits
        yLimits
        markedMinnow
        allCaught
        steps
        maxDistance
    end
    
    methods
        function obj = Shark(pos, speed, range, startingDirection, xLimits, yLimits)
            % This is the constructor for the shark
            obj.position = pos; % set the agent's new position
            obj.velocity = [0, 0]; % start the agent at zero velocity
            obj.speed = speed; % set the agent's max speed
            obj.range = range; % How close the shark needs to be to catch a minnow
            obj.historicalPosition = []; % Create this for future use
            obj.direction = startingDirection; % objects [xDirection, yDirection]
            obj.xLimits = xLimits;
            obj.yLimits = yLimits;
            obj.markedMinnow = 0; % A 0 signifies that a new minnow needs to be chosen
            obj.allCaught = 0; % When this is a 1 it means that all of the minnows have been caught
            obj.steps = 0; % Number of steps that the shark has taken
            obj.maxDistance = sqrt(max(xLimits(1),xLimits(2))^2 + max(yLimits(1),yLimits(2))^2);
        end
        
        function obj = chooseMinnow(obj, minnowList)
            %% This method is used to decide which minnow to pursue
            % To start this we calculate the closest 5 minnows
            
            % Note that minnowList is a list of all of the minnows stored
            % as objects so minnowList(1).position == minnowOne.position
            % but can be searched using an index
            
            % minnowStats is a list which will hold the distance and the
            % minnows number so that when you sort it by distance you can
            % still get the minnow's number
            minnowStats = [];
            for i=1:length(minnowList)
                % This loop will run for all of the minnows, which are all
                % contained within the minnowList
                if minnowList(i).caught == 1
                    % Remove already caught minnows
                    distance = obj.maxDistance;
                elseif minnowList(i).successfulCrossing == 1
                    distance = obj.maxDistance;
                else
                    % standard distance formula
                    distance = sqrt((obj.position(1) - minnowList(i).position(1))^2 + (obj.position(2) - minnowList(i).position(2))^2);
                end
                % put the distance in the minnowStats list
                minnowStats = [minnowStats;distance,i];
            end
            % Sort the minnowStats by the distance
            minnowStats = sortrows(minnowStats,1);
            
            if minnowStats(1,1) == obj.maxDistance
                fprintf('All minnows caught or successful.\n')
                obj.allCaught = 1;
                return
            end
            
            % Choose the 5 closes minnows as candidates
            if length(minnowList) >= 5
                minnowCandidates = minnowStats(1:5,2);
            else
                minnowCandidates = minnowStats(1:length(minnowList),2);
            end
            
            % Now that we have the minnows find the one with the closest
            % intercept point (For now this is a placeholder)
            obj.markedMinnow = minnowCandidates(1);
            
        end
        
        function obj = pursue(obj, minnow)
            %% This method pursues a minnow and marks them as caught if they 
            % get within the shark's range
            
            % Stop the loop immediately if all minnows have been caught
            if obj.allCaught == 1
                obj.steps = obj.steps + 1;
                obj.historicalPosition = [obj.historicalPosition;obj.position];
                return
            end
            
            % Stop loop if the marked minnow finishes before it gets caught
            if minnow.successfulCrossing == 1
                obj.markedMinnow = 0;
                obj.steps = obj.steps + 1;
                obj.historicalPosition = [obj.historicalPosition;obj.position];
                return
            end
            
            if minnow.steps < 6
                % Switch x and y directions to get the perpendicular
                % directions
                obj.direction(1) = minnow.direction(2);
                obj.direction(2) = minnow.direction(1);
                if abs(obj.position(1) - minnow.position(1) + obj.direction(1)) > abs(obj.position(1) - minnow.position(1) - obj.direction(1))
                    % If the distance in the positive direction is greater
                    % switch the direction to the negative direction
                    obj.direction(1) = -obj.direction(1);
                end
                if abs(obj.position(2) - minnow.position(2) + obj.direction(2)) > abs(obj.position(2) - minnow.position(2) - obj.direction(2))
                    % Same as previous if statement but for y direction
                    obj.direction(2) = -obj.direction(2);
                end
            else
                % when you have more than 5 data points use the average
                % velocity from the last 5 steps
                obj.direction(2) = (minnow.historicalPosition(minnow.steps,1)-minnow.historicalPosition(minnow.steps-5,1));
                obj.direction(1) = (minnow.historicalPosition(minnow.steps,2)-minnow.historicalPosition(minnow.steps-5,2));
                if abs(obj.position(1) - minnow.position(1) + obj.direction(1)) > abs(obj.position(1) - minnow.position(1) - obj.direction(1))
                    obj.direction(1) = -obj.direction(1);
                end
                if abs(obj.position(2) - minnow.position(2) + obj.direction(2)) > abs(obj.position(2) - minnow.position(2) - obj.direction(2))
                    obj.direction(2) = -obj.direction(2);
                end
            end
            obj.velocity(1) = obj.direction(1)*obj.speed/sqrt(obj.direction(1)^2 + obj.direction(2)^2);
            obj.velocity(2) = obj.direction(2)*obj.speed/sqrt(obj.direction(1)^2 + obj.direction(2)^2);
            if (obj.xLimits(1) <= obj.position(1) + obj.velocity(1) && obj.position(1) + obj.velocity(1) <= obj.xLimits(2))
                obj.position(1) = obj.position(1) + obj.velocity(1);
            end
            if (obj.yLimits(1) <= obj.position(2) + obj.velocity(2) && obj.position(2) + obj.velocity(2) <= obj.yLimits(2));
                obj.position(2) = obj.position(2) + obj.velocity(2);
            end
            
            % Update the list of positions
            obj.historicalPosition = [obj.historicalPosition;obj.position];
            
            % Check to see if the marked minnow is within the shark's range
            distance = sqrt((minnow.position(1)-obj.position(1))^2 + (minnow.position(2)-obj.position(2))^2);
            if distance <= obj.range
                minnow.minnowCaught();
                fprintf('Minnow %i caught on step %i.\n', obj.markedMinnow, obj.steps)
                obj.markedMinnow = 0;
            end
            
            
            obj.steps = obj.steps + 1;
        end
    end
    
end

