%% This script creates a person that moves in a random direction and we can test the algorithm

walkerY = randi([1 40],1);
robotY = randi([1 40],1);
walkerPos = [0, walkerY];
robotPos = [20, robotY];
xLimits = [0, 40];
yLimits = [0, 40];
histWalkerPos = [];
histRobotPos = [];
step = 1;
walkerSpeed = 1;
robotSpeed = 1;
proximity = 2;

n = 1000;
startingDirection = [1, 0];

minnowOne = Minnow(walkerPos, walkerSpeed, startingDirection, xLimits, yLimits);

for i=1:n
    minnowOne.randomStep(1);
    
    % PURSUIT TIME
%     if i < 7
%         robotDirection(1) = walkerDirection(2);
%         robotDirection(2) = walkerDirection(1);
%         if abs(robotPos(1) - walkerPos(1) + robotDirection(1)) > abs(robotPos(1) - walkerPos(1) - robotDirection(1))
%             robotDirection(1) = -robotDirection(1);
%         end
%         if abs(robotPos(2) - walkerPos(2) + robotDirection(2)) > abs(robotPos(2) - walkerPos(2) - robotDirection(2))
%             robotDirection(2) = -robotDirection(2);
%         end
%     else
%         % Calculate the historical velocity for more accuracy
%         robotDirection(2) = (histWalkerPos(i,1)-histWalkerPos(i-5,1));
%         robotDirection(1) = (histWalkerPos(i,2)-histWalkerPos(i-5,2));
%         if abs(robotPos(1) - walkerPos(1) + robotDirection(1)) > abs(robotPos(1) - walkerPos(1) - robotDirection(1))
%             robotDirection(1) = -robotDirection(1);
%         end
%         if abs(robotPos(2) - walkerPos(2) + robotDirection(2)) > abs(robotPos(2) - walkerPos(2) - robotDirection(2))
%             robotDirection(2) = -robotDirection(2);
%         end
%     end
%     robotXVect = robotDirection(1)*robotSpeed/sqrt(robotDirection(1)^2 + robotDirection(2)^2);
%     robotYVect = robotDirection(2)*robotSpeed/sqrt(robotDirection(1)^2 + robotDirection(2)^2);
%     if (xLimits(1) <= robotPos(1) + robotXVect && robotPos(1) + robotXVect <= xLimits(2))
%         robotPos(1) = robotPos(1) + robotXVect;
%     end
%     if (yLimits(1) <= robotPos(2) + robotYVect && robotPos(2) + robotYVect <= yLimits(2));
%         robotPos(2) = robotPos(2) + robotYVect;
%     end
%     robotVect = [robotXVect, robotYVect];
%     
%     histRobotPos = [histRobotPos;robotPos];
%     
%     RtoWDistance = sqrt((robotPos(1)-walkerPos(1))^2+(robotPos(2)-walkerPos(2))^2);
%     fprintf('%i\n',i)
%     if RtoWDistance <= proximity
%         n = i;
%         fprintf('Robot wins\n')
%         break
%     end
%     
%     if walkerPos(1) >= 39
%         fprintf('Walker wins\n')
%         break
%     end
    
end
figure

plot(minnowOne.historicalPosition(:,1), minnowOne.historicalPosition(:,2),'r',histRobotPos(:,1), histRobotPos(:,2),'b')
% animatedline(historicalPosition(:,1), historicalPosition(:,2))
xLinspace = linspace(xLimits(1), xLimits(2));
yLinspace = linspace(yLimits(1), yLimits(2));
xlim(xLimits)
ylim(yLimits)
