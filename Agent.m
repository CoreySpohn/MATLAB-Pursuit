classdef Agent
% This is the class that will hold the data for
% people participating in the experiment
    properties
        x % x position
        y % y position
        vx % x velocity
        vy % y velocity
        t % Change in time (hopefully can get a time stamp from the Cube)
    end

    methods
        function obj = setValues(x,y,t,x0,y0,t0)
            % This is the constructor for the agent
            obj.x = x; % set the agent's x position
            obj.y = y; % set the agent's y position
            obj.t = t; % record the current time within the agent
            dT = t-t0; % define the change in time between readings
            obj.vx = (x-x0)/dT; % set the agent's x velocity
            obj.vy = (y-y0)/dT; % set the agent's y velocity
        end
        
        function name = objName(obj)
            % This method will return the name of the object (I think)
            name = inputname(1);
        end
    end
end