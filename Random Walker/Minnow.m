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
        steps
        finished
        finishedStep
        goalForce
        minnowsForce
        sharksForce
        wallsForce
        totalForce
        mass
        radius
        timeInterval
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
            obj.stepsize = stepsize; % This controls how fast they can change direction
            obj.ID = ID; % The minnows number or ID
            obj.steps = 0; % counts the number of steps that the minnow takes
            obj.finished = 0; % This will serve to tell whether the minnow has been caught or reached the other side
            obj.finishedStep = intmax; % This keeps track of when they got caught
            obj.mass = 60; % (kg)
            obj.radius = 0.25; % (m)
            obj.timeInterval = 0.05; %(s)
        end

        function obj = randomStep(obj)
            %% This function is used to make the agent take a step
            % First thing is to make sure that the minnow hasn't already
            % been caught or made it to the other side
            if obj.finished == 1
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
            if obj.position(1) >= abs(obj.xLimits(2)-0.5)
                fprintf('Minnow %i wins on step %i.\n', obj.ID, obj.steps)
                obj.finished = 1;
            end
            
            % Update the list that holds all of the x and y positions for
            % the entire test
            obj.historicalPosition = [obj.historicalPosition;obj.position];
        end
        
        
        
        %% These functions are for the social force evasion model
        function obj = socialForceStep(obj, minnowList, sharkList)
            % This function will call the force functions and use their
            % outputs to move the minnow
            obj.minnowGoalForce();
            obj.minnowToMinnowForce(minnowList);
            obj.sharkToMinnowForce(sharkList);
            obj.obstacleToMinnowForce();
            obj.totalForce = obj.minnowsForce + obj.sharksForce + obj.wallsForce;
            acceleration = obj.totalForce / obj.mass;
            obj.velocity = obj.velocity + acceleration*obj.timeInterval;
        end
        
        function obj = minnowGoalForce(obj)
            % This function will generate a force in the x direction that
            % faces towards the finish line. For the current simulations it
            % only needs to be in the positive x direction
            c = 0.1; % this variable can be adjusted to give this force more influence if necessary
            goalVector = [1,0];
            goalVelocity = obj.speed*goalVector;
            obj.goalForce = obj.mass*c*(goalVelocity)/obj.timeInterval;
        end
        
        function obj = minnowToMinnowForce(obj, minnowList)
            summedForce = 0;
            A = 2e-3; % Constant used in the social force model (Newtons)
            B = 0.08; % Another constant (meters)
            k1 = 1.2e5; % SFM constant (kg/s^2)
            k2 = 2.4e5; % SFM constant (kg/(m*s))
            for i=1:length(minnowList)
                if i == obj.ID
                    % Do not try to calculate a force for the minnow to
                    % itself
                    summedForce = summedForce + 0;
                else
                    % Figure out the force for each other minnow, this
                    % calculation is following the social force model
                    radiusSum = obj.radius+minnowList(i).radius;
                    distance = norm(obj.position-minnowList(i).position);
                    unitVector = (obj.position-minnowList(i).position)/distance;
                    velocityDifference = minnowList(i).position-obj.position;
                    perpVelDiff = -unitVector(2)*velocityDifference(1) + unitVector(1)*velocityDifference(2);
                    repulsiveTerm = A * exp((radiusSum-distance)/B) * unitVector;
                    compressiveTerm = k1 * max(radiusSum-distance, 0) * unitVector;
                    frictionTerm = k2 * max(radiusSum-distance, 0) * unitVector * perpVelDiff;
                    summedForce = summedForce + repulsiveTerm + compressiveTerm + frictionTerm;
                end
                % It's worth mentioning that you could make this a lot
                % faster by using the opposite force to the other minnow
                % ahead of time. So like when you calculate the force of
                % minnow 4 on minnow 1 you also assign the opposite to
                % minnow 4 from minnow 1.
            end
            obj.minnowsForce = summedForce/length(minnowList);
        end
        
        function obj = sharkToMinnowForce(obj, sharkList)
            % This is similar to the Minnow-minnow force but has different
            % constants to keep minnows further from the sharks
            summedForce = 0;
            A = 5e-3; % Constant used in the social force model (Newtons)
            B = 0.02; % Another constant (meters)
            k1 = 1.2e5; % SFM constant (kg/s^2)
            k2 = 2.4e5; % SFM constant (kg/(m*s))
            for i=1:length(sharkList)
                if i == obj.ID
                    % Do not try to calculate a force for the shark to
                    % itself
                    summedForce = summedForce + 0;
                else
                    % Figure out the force for each other shark
                    radiusSum = obj.radius+sharkList(i).radius;
                    distance = norm(obj.position-sharkList(i).position);
                    unitVector = (obj.position-sharkList(i).position)/distance;
                    velocityDifference = sharkList(i).position-obj.position;
                    perpVelDiff = -unitVector(2)*velocityDifference(1) + unitVector(1)*velocityDifference(2);
                    repulsiveTerm = A * exp((radiusSum-distance)/B) * unitVector;
                    compressiveTerm = k1 * max(radiusSum-distance, 0) * unitVector;
                    frictionTerm = k2 * max(radiusSum-distance, 0) * unitVector * perpVelDiff;
                    summedForce = summedForce + repulsiveTerm + compressiveTerm + frictionTerm;
                end
            end
            obj.sharksForce = summedForce/length(sharkList);
        end
        
        function obj = obstacleToMinnowForce(obj)
            summedForce = 0;
            A = 2e-3; % Constant used in the social force model (Newtons)
            B = 0.08; % Another constant (meters)
            k1 = 1.2e5; % SFM constant (kg/s^2)
            k2 = 2.4e5; % SFM constant (kg/(m*s))
            
            % Find the closest x and y limits
            
            if abs(obj.xLimits(1) - obj.position(1)) > abs(obj.xLimits(2) - obj.position(1))
                closeXLimit = obj.xLimits(2);
            else
                closeXLimit = obj.xLimits(1);
            end
            
            if abs(obj.yLimits(1) - obj.position(2)) > abs(obj.yLimits(2) - obj.position(2))
                closeYLimit = obj.yLimits(2);
            else
                closeYLimit = obj.yLimits(1);
            end
            
            % Figure out the force for each the two closest walls
            distance = norm(obj.position(1)-[closeXLimit,closeYLimit]);
            unitVector = (obj.position-[closeXLimit,closeYLimit])/distance;
            velocityDifference = -obj.position;
            perpVelDiff = -unitVector(2)*velocityDifference(1) + unitVector(1)*velocityDifference(2);
            repulsiveTerm = A * exp((obj.radius-distance)/B) * unitVector;
            compressiveTerm = k1 * max(obj.radius-distance, 0) * unitVector;
            frictionTerm = k2 * max(obj.radius-distance, 0) * unitVector * perpVelDiff;
            summedForce = summedForce + repulsiveTerm + compressiveTerm + frictionTerm;
            obj.wallsForce = summedForce;
        end
    end
end