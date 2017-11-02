%% This script creates a person that moves in a random direction and we can test the algorithm
xLimits = [0, 40];
yLimits = [0, 40];
minnowSpeed = 1;
sharkSpeed = 2;
sharkRange = 4;

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

%%
%%% may want to augment shorter time series with their end positions so all
%%% position matrices have equal size. then run for lenght of shark's
figure

for ii=1:length(shark.historicalPosition)
    plot(minnowList(1).historicalPosition(:,1), minnowList(1).historicalPosition(:,2),'r-'), hold on, grid on
    plot(minnowList(2).historicalPosition(:,1), minnowList(2).historicalPosition(:,2),'b-')
    plot(minnowList(3).historicalPosition(:,1), minnowList(3).historicalPosition(:,2),'g-')
    plot(minnowList(4).historicalPosition(:,1), minnowList(4).historicalPosition(:,2),'k-')
    plot(minnowList(5).historicalPosition(:,1), minnowList(5).historicalPosition(:,2),'c-')
    plot(shark.historicalPosition(:,1), shark.historicalPosition(:,2),'k-')
    plot(minnowList(1).historicalPosition(ii,1), minnowList(1).historicalPosition(ii,2),'rs','markerfacecolor','r')
    plot(minnowList(2).historicalPosition(ii,1), minnowList(2).historicalPosition(ii,2),'bs','markerfacecolor','b')
    plot(minnowList(3).historicalPosition(ii,1), minnowList(3).historicalPosition(ii,2),'gs','markerfacecolor','g')
    plot(minnowList(4).historicalPosition(ii,1), minnowList(4).historicalPosition(ii,2),'ks','markerfacecolor','k')
    plot(minnowList(5).historicalPosition(ii,1), minnowList(5).historicalPosition(ii,2),'cs','markerfacecolor','c')
    plot(shark.historicalPosition(ii,1), shark.historicalPosition(ii,2),'ko','markerfacecolor','k')
    hold off
    xlim(xLimits)
    ylim(yLimits)
    pause(0.1)
    title(ii)

end