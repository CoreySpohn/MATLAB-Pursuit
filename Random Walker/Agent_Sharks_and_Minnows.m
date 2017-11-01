%% This script creates a person that moves in a random direction and we can test the algorithm
xLimits = [0, 40];
yLimits = [0, 40];
minnowSpeed = 1;
sharkSpeed = 1;
sharkRange = 2;

n = 1000;
startingDirection = [1, 0];

minnowOne = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 1, 1);
minnowTwo = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 0.5, 2);
minnowThree = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, .21, 3);
minnowFour = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 5, 4);
minnowFive = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 3, 5);

minnowList = [minnowOne, minnowTwo, minnowThree, minnowFour, minnowFive];

shark = Shark([40, randi([1 40],1)], sharkSpeed, sharkRange, [0,0], xLimits, yLimits);

for i=1:n
    for j=1:length(minnowList)
        % Make all of the minnows move
        minnowList(j).randomStep();
    end
    
    if shark.markedMinnow == 0
        % If no minnow is marked for pursuit then choose one
        shark.chooseMinnow(minnowList);
    end
    
    if shark.allCaught == 1
        break
    end
    
    shark.pursue(minnowList(shark.markedMinnow));
    

end
figure
plot(minnowList(1).historicalPosition(:,1), minnowList(1).historicalPosition(:,2),'r')
hold on;
plot(minnowList(2).historicalPosition(:,1), minnowList(2).historicalPosition(:,2),'b')
plot(minnowList(3).historicalPosition(:,1), minnowList(3).historicalPosition(:,2),'g')
plot(minnowList(4).historicalPosition(:,1), minnowList(4).historicalPosition(:,2),'k')
plot(minnowList(5).historicalPosition(:,1), minnowList(5).historicalPosition(:,2),'c')
plot(shark.historicalPosition(:,1), shark.historicalPosition(:,2),'ko')
xlim(xLimits)
ylim(yLimits)