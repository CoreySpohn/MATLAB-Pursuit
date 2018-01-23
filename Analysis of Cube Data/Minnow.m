classdef Human < handle
    %MINNOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID
        role
        position
        velocity
        speed
        finished
        time
        
    end    
    
    methods
        function obj = Minnow(ID, role, pos)
            %% This is the constructor for the minnow
            obj.ID = ID; % The minnows number or ID
            obj.role = role; % Indicates whether the human is a shark or minnow
            obj.position = pos; % set the minnow's new position
            obj.time = 0; % Initialize time to 0
            obj.velocity = [0, 0]; % start the minnow at zero velocity
            obj.speed = 0; % set the minnow's max speed
            obj.finished = 0; % This will serve to tell whether the minnow has been caught or reached the other side
        end

        function obj = newData(obj, x, z, t)
            %% This function is used to calculate new values after every step
            
            % Append the new position to the end of the position vector
            obj.position = [obj.position;x,z];
            
            obj.time = t;
            
            n = 5; % Points between the 
            % Get the velocity between n points
            if size(obj.position, 1) > n
                % Use this when there are more points than n
                vx = (obj.position(size(obj.position, 1), 1)-obj.position(size(obj.position, 1)-n, 1))/;
                vy = obj.position(size(obj.position, 1), 2)-obj.position(size(obj.position, 1)-n, 2);
            else
                % Use this until there are more points than n, so that you
                % don't have an index error for the first few points
                vx = obj.position(size(obj.position, 1), 1)-obj.position(1, 1); % Most recent x value - initial x value
                vy = obj.position(size(obj.position, 1), 2)-obj.position(1, 2); % 
            end
            
        end
        
    end
    
end