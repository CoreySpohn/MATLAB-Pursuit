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
        steps
        maxDistance
        
    end
    
    methods
        function obj = Shark(pos, speed, range, startingDirection, xLimits, yLimits)
            % This is the constructor for the shark
            obj.position = pos; % set the agent's new position
            obj.velocity = [0, 0]; % start the agent at zero velocity
            obj.speed = speed; % set the agent's max speed
            obj.historicalPosition = []; % Create this for future use
            obj.direction = startingDirection; % objects [xDirection, yDirection]
            obj.xLimits = xLimits;
            obj.yLimits = yLimits;
            obj.steps = 0; % Number of steps that the shark has taken
            obj.maxDistance = sqrt(max(xLimits(1),xLimits(2))^2 + max(yLimits(1),yLimits(2))^2);
        end
        
        function obj = chooseMinnow(obj, minnowList)
            % This method is used to decide which minnow to pursue
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
                
                % remove any minnow that is past the shark already
                if minnowList(i).position(1) > obj.position(1)
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
            
            % Choose the 5 closes minnows as candidates
            if length(minnowList) >= 5
                minnowCandidates = minnowStats(1:5,2);
            else
                minnowCandidates = minnowStats(1:length(minnowList),2);
            end
            
            % Now that we have the minnows find the one with the closest
            % intercept point
            obj.markedMinnow = minnowCandidates(1);
            
        end
        
        function obj = pursue(obj, minnow)
            % This method pursues a minnow
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
            
            obj.historicalPosition = [obj.historicalPosition;obj.position];
        end
    end
    
end

