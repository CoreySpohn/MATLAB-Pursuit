%% This script creates a person that moves in a random direction and we can test the algorithm

walkerY = randi([1 40],1);
robotY = randi([1 40],1);
walkerPos = [0, walkerY];
robotPos = [20, robotY];
xLimits = [0, 40];
yLimits = [0, 40];
histWalkerPos = [];
histRobotPos = [];
step = 0.5;
walkerSpeed = 1;
robotSpeed = 1;
proximity = 2;

n = 1000;
xDir = 1;
yDir = 0;
for i=1:n
    % Compute random x direction and adjust position
    xNum = randi([1 3],1);
    if xNum == 1
        xDir = xDir + step;
    elseif xNum == 2
        xDir = xDir - step;
    end
    
    % Compute random y direction and adjust position
    yNum = randi([1 3],1);
    if yNum == 1
        yDir = yDir + step;
    elseif yNum == 2
        yDir = yDir - step;
    end
    xDir = xDir / sqrt(xDir^2 + yDir^2);
    yDir = yDir / sqrt(xDir^2 + yDir^2);
    if isnan(xDir) == 1
        xDir = 0;
    end
    if isnan(yDir) == 1
        yDir = 0;
    end
        % Update position if in bounds
    if (xLimits(1) <= walkerPos(1) + xDir && walkerPos(1) + xDir <= xLimits(2))
        walkerPos(1) = walkerPos(1) + walkerSpeed*xDir;
    end
    if (yLimits(1) <= walkerPos(2) + yDir && walkerPos(2) + yDir <= yLimits(2))
        % Only update the position when it keeps the agent in bounds
        walkerPos(2) = walkerPos(2) + walkerSpeed*yDir;
    end
    walkerDirection = [xDir, yDir];
    
    histWalkerPos = [histWalkerPos;walkerPos];
    
    % PURSUIT TIME
    if i < 7
        robotDirection(1) = walkerDirection(2);
        robotDirection(2) = walkerDirection(1);
        if abs(robotPos(1) - walkerPos(1) + robotDirection(1)) > abs(robotPos(1) - walkerPos(1) - robotDirection(1))
            robotDirection(1) = -robotDirection(1);
        end
        if abs(robotPos(2) - walkerPos(2) + robotDirection(2)) > abs(robotPos(2) - walkerPos(2) - robotDirection(2))
            robotDirection(2) = -robotDirection(2);
        end
    else
        % Calculate the historical velocity for more accuracy
        robotDirection(2) = (histWalkerPos(i,1)-histWalkerPos(i-5,1));
        robotDirection(1) = (histWalkerPos(i,2)-histWalkerPos(i-5,2));
        if abs(robotPos(1) - walkerPos(1) + robotDirection(1)) > abs(robotPos(1) - walkerPos(1) - robotDirection(1))
            robotDirection(1) = -robotDirection(1);
        end
        if abs(robotPos(2) - walkerPos(2) + robotDirection(2)) > abs(robotPos(2) - walkerPos(2) - robotDirection(2))
            robotDirection(2) = -robotDirection(2);
        end
    end
    robotXVect = robotDirection(1)*robotSpeed/sqrt(robotDirection(1)^2 + robotDirection(2)^2);
    robotYVect = robotDirection(2)*robotSpeed/sqrt(robotDirection(1)^2 + robotDirection(2)^2);
    if (xLimits(1) <= robotPos(1) + robotXVect && robotPos(1) + robotXVect <= xLimits(2))
        robotPos(1) = robotPos(1) + robotXVect;
    end
    if (yLimits(1) <= robotPos(2) + robotYVect && robotPos(2) + robotYVect <= yLimits(2));
        robotPos(2) = robotPos(2) + robotYVect;
    end
    robotVect = [robotXVect, robotYVect];
    
    histRobotPos = [histRobotPos;robotPos];
    
    RtoWDistance = sqrt((robotPos(1)-walkerPos(1))^2+(robotPos(2)-walkerPos(2))^2);
    fprintf('%i\n',i)
    if RtoWDistance <= proximity
        n = i;
        fprintf('Robot wins\n')
        break
    end
    
    if walkerPos(1) >= 39
        fprintf('Walker wins\n')
        break
    end
    
end
figure

plot(histWalkerPos(:,1), histWalkerPos(:,2),'r',histRobotPos(:,1), histRobotPos(:,2),'b')
animatedline(histWalkerPos(:,1), histWalkerPos(:,2))
xLinspace = linspace(xLimits(1), xLimits(2));
yLinspace = linspace(yLimits(1), yLimits(2));
xlim(xLimits)
ylim(yLimits)
