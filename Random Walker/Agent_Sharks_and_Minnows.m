%% This script creates a person that moves in a random direction and we can test the algorithm
xLimits = [0, 40];
yLimits = [0, 40];
minnowSpeed = 1;
sharkSpeed = 1;
proximity = 2;

n = 1000;
startingDirection = [1, 0];

minnowOne = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 1);
minnowTwo = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 0.5);
minnowThree = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, .21);
minnowFour = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 5);
minnowFive = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 3);

minnowList = [minnowOne, minnowTwo, minnowThree, minnowFour, minnowFive];

shark = Shark([40, randi([1 40],1)], sharkSpeed, [0,0], xLimits, yLimits);

for i=1:n
    for j=1:length(minnowList)
        minnowList(j).randomStep();
    end
    
    shark.pursue(minnowOne);
    
%     RtoWDistance = sqrt((robotPos(1)-minnowOne.position(1))^2+(robotPos(2)-minnowOne.position(2))^2);
%     fprintf('%i\n',i)
%     if RtoWDistance <= proximity
%         n = i;
%         fprintf('Robot wins\n')
%         break
%     end
%     
%     if minnowOne.position(1) >= 39
%         fprintf('Walker wins\n')
%         break
%     end
    
end
figure

% plot(minnowOne.historicalPosition(:,1), minnowOne.historicalPosition(:,2),'r',histRobotPos(:,1), histRobotPos(:,2),'b')

plot(minnowList(1).historicalPosition(:,1), minnowList(1).historicalPosition(:,2),'r')
hold on;
plot(minnowList(2).historicalPosition(:,1), minnowList(2).historicalPosition(:,2),'b')
plot(minnowList(3).historicalPosition(:,1), minnowList(3).historicalPosition(:,2),'g')
plot(minnowList(4).historicalPosition(:,1), minnowList(4).historicalPosition(:,2),'w')
plot(minnowList(5).historicalPosition(:,1), minnowList(5).historicalPosition(:,2),'c')
plot(shark.historicalPosition(:,1), shark.historicalPosition(:,2),'ko')
xLinspace = linspace(xLimits(1), xLimits(2));
yLinspace = linspace(yLimits(1), yLimits(2));
xlim(xLimits)
ylim(yLimits)



