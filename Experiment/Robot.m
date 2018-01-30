classdef Robot < handle
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
        ID
        role
        time
        markedMinnow
        allCaught
        steps
        maxDistance
    end
    
    methods
        function obj = Robot(ID, role, pos, speed, range, xLimits, yLimits)
            % This is the constructor for the shark
            obj.ID = ID; % Robot's ID number
            obj.role = role; % Whether the robot is a shark or minnow
            obj.position = pos; % set the agent's new position
            obj.velocity = [0, 0]; % start the agent at zero velocity
            obj.speed = speed; % set the agent's max speed
            obj.range = range; % How close the shark needs to be to catch a minnow
            obj.historicalPosition = []; % Create this for future use
            obj.xLimits = xLimits;
            obj.yLimits = yLimits;
            obj.markedMinnow = 0; % A 0 signifies that a new minnow needs to be chosen
            obj.allCaught = 0; % When this is a 1 it means that all of the minnows have been caught
            obj.steps = 0; % Number of steps that the shark has taken
            obj.maxDistance = sqrt(max(xLimits(1),xLimits(2))^2 + max(yLimits(1),yLimits(2))^2);
            obj.time = 0; % start the time at 0
        end
        
        function obj = newData(obj, motionData)
            obj.position = [motionData(1, obj.ID), motionData(3, obj.ID)];
            
            if isempty(obj.historicalPosition) == 1
                obj.historicalPosition = [obj.position];
            else
                obj.historicalPosition = [obj.historicalPosition; obj.position];
            end
            
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
                if minnowList(i).finished == 0
                    % Make a list of minnows who aren't caught or to the
                    % other side and calculate their distance
                    distance = sqrt((obj.position(1) - minnowList(i).position(1))^2 + (obj.position(2) - minnowList(i).position(2))^2);
                    minnowStats = [minnowStats;distance,i];
                end
            end
            
            if isempty(minnowStats) == 1
                % if there are no minnows who aren't caught or successful
                % then say so
                fprintf('All minnows caught or successful.\n')
                obj.allCaught = 1;
                return
            end
            
            % Sort the minnowStats by the distance
            
            % minnowStats = sortrows(minnowStats,1);

            % Now that we have the minnows find the one with the closest
            % intercept point
            minnowInterceptionTimeList = [];
            for jj=1:size(minnowStats,1)
                % This loop will calculate the time to interception for the
                % 5 closest minnows.
                distanceVector = obj.position - minnowList(minnowStats(jj,2)).position;
                distance = norm(distanceVector);
                
                % quadratic coefficients
                a = (obj.speed^2 - minnowList(minnowStats(jj,2)).speed^2);
                b = 2*dot(distanceVector, minnowList(minnowStats(jj,2)).velocity);
                c = - distance^2;
                
                if a == 0
                    % When this is the case the quadratic relationship
                    % doesn't hold so the solution is the following
                    t1 = -c / b;
                    t2 = t1;
                elseif b^2 - 4*a*c < 0
                    % This makes sure the result isn't imaginary, the
                    % values of -1 will disregard the result when it gets
                    % to the next if statement
                    t1 = -1;
                    t2 = -1;
                else
                    t1 = (-b + sqrt(b^2 - 4*a*c))/(2*a);
                    t2 = (-b - sqrt(b^2 - 4*a*c))/(2*a);
                end
                
                % Now run through checks to determine which time calculated
                % should be used
                if t1 < 0 && t2 < 0
                    % No solution that doesn't involve time travel
                    tFinal = obj.maxDistance;
                elseif t1 > 0 && t2 > 0
                    % When both are positive choose the one with the shortest
                    % time
                    tFinal = min(t1, t2);
                elseif t1 == t2
                    tFinal = t1;
                else
                    % When only one is positive choose that one
                    tFinal = max(t1, t2);
                end
                minnowInterceptionTimeList = [minnowInterceptionTimeList;tFinal,minnowStats(jj,2)];
            end
            % After getting all of the times to interception sort the list
            % and mark the one with the closest time to interception
            
            minnowInterceptionTimeList = sortrows(minnowInterceptionTimeList,1);
            obj.markedMinnow = minnowInterceptionTimeList(1,2);
        end
        
        
        
        function obj = sharkMove(obj, minnow, minnowList)
            %% This is a function using a newer pursuit algorithm
            
            % Stop the loop immediately if all minnows have been caught
            if obj.allCaught == 1
                obj.historicalPosition = [obj.historicalPosition;obj.position];
                return
            end
            
            if minnowList(obj.markedMinnow).finished == 1
                % If the code fucks up and the inputs a minnow that is
                % finished already, kick that shit out
                obj.markedMinnow = 0;
                obj.chooseMinnow2(minnowList);
                obj.historicalPosition = [obj.historicalPosition;obj.position];
                return
            end
            
            distanceVector = obj.position - minnow.position;
            distance = norm(distanceVector);
            
            % quadratic coefficients
            a = (obj.speed^2 - minnow.speed^2);
            b = 2*dot(distanceVector, minnow.velocity);
            c = - norm(distanceVector)^2;
            
            if a == 0
                t1 = -c / b;
                t2 = t1;
            elseif b^2 - 4*a*c < 0
                % This makes sure the result isn't imaginary
                obj.markedMinnow = 0;
                return
            else
                t1 = (-b + sqrt(b^2 - 4*a*c))/(2*a);
                t2 = (-b - sqrt(b^2 - 4*a*c))/(2*a);
            end
                        
            if t1 < 0 && t2 < 0
                % No solution
                obj.markedMinnow = 0;
                return
            end
            
            if t1 > 0 && t2 > 0
                % When both are positive choose the one with the shortest
                % time
                tFinal = min(t1, t2);
            elseif t1 == t2
                tFinal = t1;
            else
                % When only one is positive choose that one
                tFinal = max(t1, t2);
            end
            
            interceptionPoint = minnow.position + minnow.velocity * tFinal;

            obj.velocity = (interceptionPoint - obj.position) / tFinal;
            
            if (obj.xLimits(1) <= obj.position(1) + obj.velocity(1) && obj.position(1) + obj.velocity(1) <= obj.xLimits(2))
                obj.position(1) = obj.position(1) + obj.velocity(1);
            end
            if (obj.yLimits(1) <= obj.position(2) + obj.velocity(2) && obj.position(2) + obj.velocity(2) <= obj.yLimits(2));
                obj.position(2) = obj.position(2) + obj.velocity(2);
            end
            
            if isnan(obj.velocity(1)) == 1
                obj.markedMinnow = 0;
                obj.chooseMinnow(minnowList);
            end
            
            % Update the list of positions
            obj.historicalPosition = [obj.historicalPosition;obj.position];
            
            % Check to see if any minnows are within the shark's range
            
            % minnowStats is a list which will hold the distance, the
            % minnows number, and if it's been caught
            minnowStats = [];
            for i=1:length(minnowList)
                % This loop will run for all of the minnows, which are all
                % contained within the minnowList
                if minnowList(i).finished == 1
                    % Remove already caught minnows
                    distance = obj.maxDistance;
                else
                    % standard distance formula
                    distance = sqrt((obj.position(1) - minnowList(i).position(1))^2 + (obj.position(2) - minnowList(i).position(2))^2);
                end
                % put the distance in the minnowStats list
                minnowStats = [minnowStats;distance,i];
            end

            for ii=1:length(minnowStats)
                if minnowStats(ii,1) <= obj.range
                    minnowList(ii).finished = 1;
                    minnowList(ii).finishedStep = obj.steps;
                    fprintf('Minnow %i caught on step %i by shark %i.\n', ii, obj.steps, obj.ID)
                    obj.markedMinnow = 0;
                end
            end
            
        end
        %% This is the evasion algorithm
        function obj = minnowMove(obj, minnowList, sharkList, roundNum)
            % This function will call the force functions and use their
            % outputs to move the minnow
            obj.minnowGoalForce(roundNum);
            obj.minnowToMinnowForce(minnowList);
            obj.sharkToMinnowForce(sharkList);
%             obj.obstacleToMinnowForce();
%             obj.totalForce = obj.minnowsForce + obj.sharksForce + obj.wallsForce;
            obj.totalForce = obj.minnowsForce + obj.goalForce + obj.sharksForce;
            acceleration = obj.totalForce / obj.mass;
            obj.velocity = obj.velocity + acceleration*obj.timeInterval;
            obj.nextPosition = obj.currentPosition + obj.velocity*obj.timeInterval;
            
            % Make sure that the minnow doesn't get to leave the field of
            % play
            if obj.nextPosition(1) < obj.xLimits(1)
                obj.nextPosition(1) = obj.xLimits(1);
            end
            
            if obj.nextPosition(2) < obj.yLimits(1)
                obj.nextPosition(2) = obj.yLimits(1);
            elseif obj.nextPosition(2) > obj.yLimits(2)
                obj.nextPosition(2) = obj.yLimits(2);
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
            c = 0.1; % this variable can be adjusted to give this force more influence if necessary
            
            if mod(roundNum, 2) == 1
                % If it's an odd round number then the robot should try to
                % move in the positive x direction
                goalVector = [1,0];
            else
                goalVector = [-1,0];
            end
            
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
                    distance = norm(obj.currentPosition-minnowList(i).currentPosition);
                    unitVector = (obj.currentPosition-minnowList(i).currentPosition)/distance;
                    velocityDifference = minnowList(i).currentPosition-obj.currentPosition;
                    perpVelDiff = -unitVector(2)*velocityDifference(1) + unitVector(1)*velocityDifference(2);
                    repulsiveTerm = A * exp((radiusSum-distance)/B) * unitVector;
                    compressiveTerm = k1 * max(radiusSum-distance, 0) * unitVector;
                    frictionTerm = k2 * max(radiusSum-distance, 0) * unitVector * perpVelDiff;
                    summedForce = summedForce + repulsiveTerm + compressiveTerm + frictionTerm;
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
                    distance = norm(obj.currentPosition-sharkList(i).position);
                    unitVector = (obj.currentPosition-sharkList(i).position)/distance;
                    velocityDifference = sharkList(i).position-obj.currentPosition;
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
            
            if abs(obj.xLimits(1) - obj.currentPosition(1)) > abs(obj.xLimits(2) - obj.currentPosition(1))
                closeXLimit = obj.xLimits(2);
            else
                closeXLimit = obj.xLimits(1);
            end
            
            if abs(obj.yLimits(1) - obj.currentPosition(2)) > abs(obj.yLimits(2) - obj.currentPosition(2))
                closeYLimit = obj.yLimits(2);
            else
                closeYLimit = obj.yLimits(1);
            end
            
            % Figure out the force for each the two closest walls
            distance = norm(obj.currentPosition(1)-[closeXLimit,closeYLimit]);
            unitVector = (obj.currentPosition-[closeXLimit,closeYLimit])/distance;
            velocityDifference = -obj.currentPosition;
            perpVelDiff = -unitVector(2)*velocityDifference(1) + unitVector(1)*velocityDifference(2);
            repulsiveTerm = A * exp((obj.radius-distance)/B) * unitVector;
            compressiveTerm = k1 * max(obj.radius-distance, 0) * unitVector;
            frictionTerm = k2 * max(obj.radius-distance, 0) * unitVector * perpVelDiff;
            summedForce = summedForce + repulsiveTerm + compressiveTerm + frictionTerm;
            obj.wallsForce = summedForce;
        end
    end
    
end

