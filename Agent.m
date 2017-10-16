classdef Agent
% This is the class that will hold the data for
% people participating in the experiment
    properties
        x % x position
        y % y position
        vx % x velocity
        vy % y velocity
        dT = 0.01 % Change in time (currently a dummy variable)
    end
    
    methods
        function obj = initialPosition(x,y,x0,y0)
            %% This is the constructor for the agent
            obj.x = x; % set the agent's x position
            obj.y = y; % set the agent's y position
            obj.vx = (x-x0)/dT; % set the agent's x velocity
            obj.vy = (y-y0)/dT; % set the agent's y velocity
        end
    end
end