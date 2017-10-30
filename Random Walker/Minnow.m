classdef Minnow
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
    end
    
    methods
        function obj = Minnow(pos, speed, startingDirection, xLimits, yLimits)
            %% This is the constructor for the agent
            obj.position = pos; % set the agent's new position
            obj.velocity = [0, 0]; % start the agent at zero velocity
            obj.speed = speed; % set the agent's max speed
            obj.historicalPosition = []; % Create this for future use
            obj.direction = startingDirection; % objects [xDirection, yDirection]
            obj.xLimits = xLimits;
            obj.yLimits = yLimits;
        end
        
        function step = randomStep(obj, step)
            %% This function is used to make the agent take a step
            
            % Random x direction
            xNum = randi([1 2],1);
            if xNum == 1
                obj.direction(1) = obj.direction(1) + step;
            end
            
            % Compute random y direction
            yNum = randi([1 3],1);
            if yNum == 1
                obj.direction(2) = obj.direction(2) + step;
            elseif yNum == 2
                obj.direction(2) = obj.direction(2) - step;
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
            
            % Update position if in bounds
            if (obj.xLimits(1) <= obj.position(1) + obj.direction(1) && obj.position(1) + obj.direction(1) <= obj.xLimits(2))
                obj.position(1) = obj.position(1) + obj.speed * obj.direction(1);
            end
            if (obj.yLimits(1) <= obj.position(2) + obj.direction(2) && obj.position(2) + obj.direction(2) <= obj.yLimits(2))
                % Only update the position when it keeps the agent in bounds
                obj.position(2) = obj.position(2) + obj.speed * obj.direction(2);
            end
            
            obj.historicalPosition = [obj.historicalPosition;obj.position];
        end
    end
    
end

