%% This script creates a person that moves in a random direction and we can test the algorithm

walkerPos = [20, 20];
robotPos = [10, 10];
xLimits = [0, 40];
yLimits = [0, 40];
histWalkerPos = [];

n = 400;

for i=1:n
    % Compute random x direction and adjust position
    xNum = randi([1 3],1);
    if xNum == 1
        xDir = 1;
    elseif xNum == 2
        xDir = -1;
    else
        xDir = 0;
    end
    % Update position if in bounds
    if (xLimits(1) <= walkerPos(1) + xDir <= xLimits(2))
        walkerPos(1) = walkerPos(1) + xDir;
    end
    
    
    % Compute random y direction and adjust position
    yNum = randi([1 3],1);
    if yNum == 1
        yDir = 1;
    elseif yNum == 2
        yDir = -1;
    else
        yDir = 0;
    end
    if (yLimits(1) <= walkerPos(2) + yDir <= yLimits(2))
        walkerPos(2) = walkerPos(2) + yDir;
    end
    direction = [xDir, yDir];
    
    histWalkerPos = [histWalkerPos;walkerPos];
end
plot(histWalkerPos(:,1), histWalkerPos(:,2))
xLinspace = linspace(xLimits(1), xLimits(2));
yLinspace = linspace(yLimits(1), yLimits(2));
xlim(xLimits)
ylim(yLimits)