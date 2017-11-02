classdef Minnow < handle
    %MINNOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position
        velocity
        speed
        historicalPosition
        direction
        xLimits
        yLimits
        stepsize
        ID
        successfulCrossing
        steps
        caught
        caughtStep
    end    
    
    methods (Static)
        % This was an attepmt to make a list that keeps track of the
        % minnows created without having to do it manually
        function minnowList = newMinnow(obj)
            mlock
            persistent var;
            if isempty(var); var = []; end
            if nargin < 1; minnowList = [var, obj]; return; end
            var = obj;
        end
    end
    
    methods
        function obj = Minnow(pos, speed, startingDirection, xLimits, yLimits, stepsize, ID)
            %% This is the constructor for the minnow
            obj.position = pos; % set the minnow's new position
            obj.velocity = [0, 0]; % start the minnow at zero velocity
            obj.speed = speed; % set the minnow's max speed
            obj.historicalPosition = []; % Create this for future use
            obj.direction = startingDirection; % objects [xDirection, yDirection]
            obj.xLimits = xLimits;
            obj.yLimits = yLimits;
            obj.successfulCrossing = 0; % if 1 then they have reached the xLimit
            obj.stepsize = stepsize; % This controls how fast they can change direction
            obj.ID = ID; % The minnows number or ID
            obj.steps = 1; % counts the number of steps that the minnow takes
            obj.caught = 0; % This will serve to tell whether the minnow has been caught
            obj.caughtStep = intmax; % This keeps track of when they got caught
        end

        function obj = randomStep(obj)
            %% This function is used to make the agent take a step
            % First thing is to make sure that the minnow hasn't already
            % been caught or made it to the other side
            if obj.caught == 1
                obj.historicalPosition = [obj.historicalPosition;obj.position];
                return
            end
            
            if obj.successfulCrossing == 1
                obj.historicalPosition = [obj.historicalPosition;obj.position];
                return
            end
            
            % Choose the randomn direction and determine the velocity vector
            % Random x direction
            xNum = randi([1 3],1);
            if xNum == 1
                obj.direction(1) = obj.direction(1) + obj.stepsize;
            elseif xNum == 3 && (0 < obj.direction(1) - obj.stepsize)
                obj.direction(1) = obj.direction(1) - obj.stepsize;
            end
            
            % Compute random y direction
            yNum = randi([1 3],1);
            if yNum == 1
                obj.direction(2) = obj.direction(2) + obj.stepsize;
            elseif yNum == 2
                obj.direction(2) = obj.direction(2) - obj.stepsize;
            end
            
            % Calculate the direction unit vector
            obj.direction(1) = obj.direction(1) / sqrt(obj.direction(1)^2 + obj.direction(2)^2);
            obj.direction(2) = obj.direction(2) / sqrt(obj.direction(1)^2 + obj.direction(2)^2);
            % Remove any nan values
            if isnan(obj.direction(1)) == 1
                obj.direction(1) = 0;
            end
            if isnan(obj.direction(2)) == 1
                obj.direction(2) = 0;
            end
            
            % Update the agent's position
            if obj.xLimits(1) <= obj.position(1) + obj.direction(1) && obj.position(1) + obj.direction(1) <= obj.xLimits(2)
                % Check to make sure that the agent is within the limits of
                % field and if so update it
                obj.position(1) = obj.position(1) + obj.speed * obj.direction(1);
            elseif obj.position(1) + obj.direction(1) <= obj.xLimits(1)
                % if the position would be less than the minimum x limit,
                % set the position to the minumum x limit
                obj.position(1) = obj.xLimits(2);
            else
                % If neither of the previous ones are true then set it to
                % the maximum x limit
                obj.position(1) = obj.xLimits(2);
            end
            
            % Same as the previous block but for the y direction
            if obj.yLimits(1) <= obj.position(2) + obj.direction(2) && obj.position(2) + obj.direction(2) <= obj.yLimits(2)
                obj.position(2) = obj.position(2) + obj.speed * obj.direction(2);
            elseif obj.position(2) + obj.direction(2) <= obj.yLimits(1)
                obj.position(2) = obj.yLimits(1);
            else
                obj.position(2) = obj.yLimits(2);
            end
            
            % Check to see whether the minnow has gotten to the other side
            if obj.position(1) == obj.xLimits(2)
                fprintf('Minnow %i wins on step %i.\n', obj.ID, obj.steps)
                obj.successfulCrossing = 1;
            end
            
            % Update the list that holds all of the x and y positions for
            % the entire test
            obj.historicalPosition = [obj.historicalPosition;obj.position];
        end
        
    end
    
end