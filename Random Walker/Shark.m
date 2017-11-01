classdef Shark < handle
    %SHARK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position
        velocity
        speed
        historicalPosition
        direction
        xLimits
        yLimits
        markedMinnow
        steps
    end
    
    methods
        function obj = Shark(pos, speed, startingDirection, xLimits, yLimits)
            %% This is the constructor for the shark
            obj.position = pos; % set the agent's new position
            obj.velocity = [0, 0]; % start the agent at zero velocity
            obj.speed = speed; % set the agent's max speed
            obj.historicalPosition = []; % Create this for future use
            obj.direction = startingDirection; % objects [xDirection, yDirection]
            obj.xLimits = xLimits;
            obj.yLimits = yLimits;
            obj.steps = 0;
        end
        
        function obj = chooseMinnow(obj, minnowList)
            empty
        end
        
        function obj = pursue(obj, minnow)
            if minnow.steps < 7
                obj.direction(1) = minnow.direction(2);
                obj.direction(2) = minnow.direction(1);
                if abs(obj.position(1) - minnow.position(1) + obj.direction(1)) > abs(obj.position(1) - minnow.position(1) - obj.direction(1))
                    obj.direction(1) = -obj.direction(1);
                end
                if abs(obj.position(2) - minnow.position(2) + obj.direction(2)) > abs(obj.position(2) - minnow.position(2) - obj.direction(2))
                    obj.direction(2) = -obj.direction(2);
                end
            else
                % Calculate the historical velocity for more accuracy
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

