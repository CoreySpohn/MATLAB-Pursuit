classdef Human < handle
    
    properties
        ID
        role
        position
        historicalPosition
        velocity
        speed
        finished
        time
        name
    end    
    
    methods
        function obj = Human(ID, role, name)
            %% This is the constructor for the minnow
            obj.ID = ID; % The minnows number or ID
            obj.role = role; % Indicates whether the human is a shark or minnow
            obj.historicalPosition = [];
            obj.time = 0; % Initialize time to 0
            obj.velocity = [0, 0]; % start the minnow at zero velocity
            obj.speed = 0; % set the minnow's max speed
            obj.finished = 0; % This will serve to tell whether the minnow has been caught or reached the other side
            obj.name = name; % This is the name on the hat
        end

        function obj = newData(obj, motionData, goalPoint)
            %% This function is used to calculate new values after every step
            
            if obj.finished == 1
                % If the minnow has been caught then don't update it's
                % position to anything new
                obj.historicalPosition = [obj.historicalPosition; obj.position];
                return
            end
            
            obj.position = [motionData(1, obj.ID), motionData(3, obj.ID)];
            
            % Check to see if the human is a minnow and then see if they 
            % are across the field
            if strcmp(obj.role, 'Minnow')
                if goalPoint < 0 && obj.position(1) < goalPoint
                    % If the goal is negative and the human has gotten
                    obj.finished = 1;
                elseif goalPoint > 0 && obj.position(1) > goalPoint
                    obj.finished = 1;
                end
            end
            % obj.time = positionData(1); % Need to use Verbose data collection
            
            % Append the new position to the end of the position vector
            % unless it's the first time
            if isempty(obj.historicalPosition) == 1
               obj.historicalPosition = [obj.position];
            else
                obj.historicalPosition = [obj.historicalPosition; obj.position];
            end
            
            
            
            n = 5; % Points between the 
            % Get the velocity between n points
            if size(obj.position, 1) > n
                % Use this when there are more points than n
                vx = (obj.position(size(obj.position, 1), 1)-obj.position(size(obj.position, 1)-n, 1))/t;
                vy = (obj.position(size(obj.position, 1), 2)-obj.position(size(obj.position, 1)-n, 2))/t;
            else
                % Use this until there are more points than n, so that you
                % don't have an index error for the first few points
                vx = (obj.position(size(obj.position, 1), 1)-obj.position(1, 1))/t; % Most recent x value - initial x value
                vy = (obj.position(size(obj.position, 1), 2)-obj.position(1, 2))/t; % 
            end
            
            obj.velocity = [vx, vy];
        end
        
    end
    
end