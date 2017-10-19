function velocity = Velocity_calc(x, x0, dT)
% This function will calculate the velocity between two points with
% a given time interval.
% If the position given is 
    if isnan(x)
        velocity = NaN;
    elseif isnan(x0)
        velocity = NaN;
    else
        velocity = (x-x0)/dT;
    end
end