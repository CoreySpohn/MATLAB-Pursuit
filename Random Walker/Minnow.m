classdef Minnow < handle
    %MINNOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        currentPosition
        nextPosition
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
            % This is the constructor for the minnow
            obj.currentPosition = pos; % set the minnow's new position
            obj.velocity = [0, 0]; % start the minnow at zero velocity
            obj.speed = speed; % set the minnow's max speed
            obj.historicalPosition = [pos]; % Create this for future use
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
                obj.historicalPosition = [obj.historicalPosition;obj.currentPosition];
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
            if obj.xLimits(1) <= obj.currentPosition(1) + obj.direction(1) && obj.currentPosition(1) + obj.direction(1) <= obj.xLimits(2)
                % Check to make sure that the agent is within the limits of
                % field and if so update it
                obj.currentPosition(1) = obj.currentPosition(1) + obj.speed * obj.direction(1);
            elseif obj.currentPosition(1) + obj.direction(1) <= obj.xLimits(1)
                % if the position would be less than the minimum x limit,
                % set the position to the minumum x limit
                obj.currentPosition(1) = obj.xLimits(2);
            else
                % If neither of the previous ones are true then set it to
                % the maximum x limit
                obj.currentPosition(1) = obj.xLimits(2);
            end
            
            % Same as the previous block but for the y direction
            if obj.yLimits(1) <= obj.currentPosition(2) + obj.direction(2) && obj.currentPosition(2) + obj.direction(2) <= obj.yLimits(2)
                obj.currentPosition(2) = obj.currentPosition(2) + obj.speed * obj.direction(2);
            elseif obj.currentPosition(2) + obj.direction(2) <= obj.yLimits(1)
                obj.currentPosition(2) = obj.yLimits(1);
            else
                obj.currentPosition(2) = obj.yLimits(2);
            end
            
            % Check to see whether the minnow has gotten to the other side
            if obj.currentPosition(1) >= abs(obj.xLimits(2)-0.5)
                fprintf('Minnow %i wins on step %i.\n', obj.ID, obj.steps)
                obj.finished = 1;
            end
            
            % Update the list that holds all of the x and y positions for
            % the entire test
            obj.historicalPosition = [obj.historicalPosition;obj.currentPosition];
        end
        
        %% These functions are for the social force evasion model
        function obj = socialForceStep(obj, minnowList, sharkList)
            % This function will call the force functions and use their
            % outputs to move the minnow
            
            % First check to see if the minnow is finished
            if obj.finished == 1
                obj.historicalPosition = [obj.historicalPosition;obj.currentPosition];
                return
            end
            
            obj.minnowGoalForce();
            obj.minnowToMinnowForce(minnowList);
            obj.sharkToMinnowForce(sharkList);
%             obj.obstacleToMinnowForce();
            obj.totalForce = obj.minnowsForce + obj.goalForce + obj.sharksForce;
            forceUnitVector = obj.totalForce / norm(obj.totalForce);
            obj.nextPosition = obj.currentPosition + obj.speed*forceUnitVector;
            
            step = obj.steps;
            while isnan(obj.nextPosition) == 1
                % I've got a bug and I'm doing a quick fix that I'll
                % probably not fix fully
                obj.nextPosition = obj.historicalPosition(step,:);
                step = step - 1;
            end
            
%             acceleration = obj.totalForce / obj.mass;
%             obj.velocity = obj.velocity + acceleration*obj.timeInterval;
%             obj.nextPosition = obj.currentPosition + obj.velocity*obj.timeInterval;
            
            % Make sure that the minnow doesn't get to leave the field of
            % play
            if obj.nextPosition(1) < obj.xLimits(1)
                obj.nextPosition(1) = obj.xLimits(1);
                obj.nextPosition(2) = obj.currentPosition(2) + obj.speed;
            end
            
            if obj.nextPosition(2) < obj.yLimits(1)
                obj.nextPosition(2) = obj.yLimits(1);
                obj.nextPosition(1) = obj.currentPosition(1) + obj.speed;
            elseif obj.nextPosition(2) > obj.yLimits(2)
                obj.nextPosition(2) = obj.yLimits(2);
                obj.nextPosition(1) = obj.currentPosition(1) + obj.speed;
            end
            
            if obj.nextPosition(1) >= abs(obj.xLimits(2)-0.5)
                fprintf('Minnow %i wins on step %i.\n', obj.ID, obj.steps)
                obj.finished = 1;
            end
            
            obj.historicalPosition = [obj.historicalPosition;obj.nextPosition];
        end
        
        function obj = minnowGoalForce(obj)
            % This function will generate a force in the x direction that
            % faces towards the finish line. For the current simulations it
            % only needs to be in the positive x direction
            c = 2e3; % this variable can be adjusted to give this force more influence if necessary
            goalVector = [1,0];
            goalVelocity = obj.speed*goalVector;
            obj.goalForce = obj.mass*c*(goalVelocity)/obj.timeInterval;
        end
        
        function obj = minnowToMinnowForce(obj, minnowList)
            summedForce = 0;
            A = 2e3; % Constant used in the social force model (Newtons)
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
                    distance = norm(obj.currentPosition-minnowList(i).currentPosition);
                    unitVector = (obj.currentPosition-minnowList(i).currentPosition)/distance;
                    velocityDifference = minnowList(i).currentPosition-obj.currentPosition;
                    perpVelDiff = -unitVector(2)*velocityDifference(1) + unitVector(1)*velocityDifference(2);
                    repulsiveTerm = A * exp((radiusSum-distance)/B) * unitVector;
                    if isnan(repulsiveTerm) == 1
                        repulsiveTerm = [0, 0];
                    end
%                     compressiveTerm = k1 * max(radiusSum-distance, 0) * unitVector;
%                     frictionTerm = k2 * max(radiusSum-distance, 0) * unitVector * perpVelDiff;
                    summedForce = summedForce + repulsiveTerm;
%                     fprintf('Minnow %i acting on minnow %i is: %i\n', i, obj.ID, summedForce)
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
            A = 2e2; % Constant used in the social force model (Newtons)
            B = 0.08; % Another constant (meters)
            reactionRange = 20;
            for i=1:length(sharkList)
                if i == obj.ID
                    % Do not try to calculate a force for the shark to
                    % itself
                    summedForce = summedForce + 0;
                else
                    % Figure out the force for each other shark
                    radiusSum = obj.radius+sharkList(i).radius + reactionRange;
                    distance = norm(obj.currentPosition-sharkList(i).position);
                    unitVector = (obj.currentPosition-sharkList(i).position)/distance;
                    repulsiveTermExp = exp((radiusSum-distance)) * unitVector;
                    repulsiveTermStatic = 8e6 * unitVector;
                    repulsiveTerm = max(repulsiveTermExp, repulsiveTermStatic);
                    summedForce = summedForce + repulsiveTerm;
                end
            end
            obj.sharksForce = summedForce/length(sharkList);
        end
        
        function obj = obstacleToMinnowForce(obj)
            summedForce = 0;
            A = 2e3; % Constant used in the social force model (Newtons)
            B = 0.08; % Another constant (meters)
            
            % Find the closest x and y limits
            if abs(obj.currentPosition(1) - obj.xLimits(1)) < abs(obj.currentPosition(1) - obj.xLimits(2))
                closeXLimit = obj.xLimits(1);
            else
                closeXLimit = obj.xLimits(2);
            end
            
            if abs(obj.currentPosition(2) - obj.yLimits(1)) < abs(obj.currentPosition(2) - obj.yLimits(2))
                closeYLimit = obj.yLimits(1);
            else
                closeYLimit = obj.yLimits(2);
            end
            
            % Figure out the force for each the two closest walls
            distance = norm(obj.currentPosition(1)-[closeXLimit,closeYLimit]);
            unitVector = (obj.currentPosition-[closeXLimit,closeYLimit])/distance;
            repulsiveTerm = A * exp((obj.radius-distance)/B) * unitVector;
            summedForce = summedForce + repulsiveTerm;
            obj.wallsForce = summedForce;
        end
    end
end