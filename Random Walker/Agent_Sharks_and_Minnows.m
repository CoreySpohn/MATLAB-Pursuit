%% This script creates a person that moves in a random direction and we can test the algorithm
xLimits = [0, 40];
yLimits = [0, 40];
minnowSpeed = 1;
sharkSpeed = 2;
sharkRange = 2;

n = 1000;
startingDirection = [1, 0];

minnowOne = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 1, 1);
minnowTwo = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 0.1, 2);
minnowThree = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, .1, 3);
minnowFour = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 1, 4);
minnowFive = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 1, 5);
minnowSix = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 1, 6);
minnowSeven = Minnow([0, randi([1 40],1)], minnowSpeed, startingDirection, xLimits, yLimits, 1, 7);

minnowList = [minnowOne, minnowTwo, minnowThree, minnowFour, minnowFive, minnowSix, minnowSeven];

sharkOne = Shark([40, randi([1 20],1)], sharkSpeed, sharkRange, [-1,0], xLimits, yLimits, 1);
sharkTwo = Shark([40, randi([21 40],1)], sharkSpeed, sharkRange, [-1,0], xLimits, yLimits, 2);
sharkList = [sharkOne, sharkTwo];

for i=1:n
    for j=1:length(minnowList)
        % Make all of the minnows move
        minnowList(j).randomStep();
        minnowList(j).steps = minnowList(j).steps + 1;
    end
    
    for ii=1:length(sharkList)
        %% Make sharks react to the minnows        
        if sharkList(ii).markedMinnow == 0 && sharkList(ii).allCaught == 0
            % If no minnow is marked for pursuit then choose one
            fprintf('Shark %i choosing on step %i\n', ii, i)
            sharkList(ii).chooseMinnow(minnowList);
        end
        if sharkList(ii).allCaught == 0
            sharkList(ii).pursue(minnowList(sharkList(ii).markedMinnow),minnowList);
            sharkList(ii).steps = sharkList(ii).steps + 1;
        else
            for ij=1:length(sharkList)
                % Tell all sharks that the minnows have been caught
                % and which step it happened on
                if length(sharkList(ij).historicalPosition) < sharkList(ii).historicalPosition
                    sharkList(ij).historicalPosition = [sharkList(ij).historicalPosition;sharkList(ij).position];
                end
                sharkList(ij).allCaught = 1;
            end
            
        end
    end
    
end

%%

figure
for ii=1:min(length(sharkList(1).historicalPosition),length(sharkList(2).historicalPosition))
    plot(minnowList(1).historicalPosition(:,1), minnowList(1).historicalPosition(:,2),'r-'), hold on, grid on
    plot(minnowList(2).historicalPosition(:,1), minnowList(2).historicalPosition(:,2),'b-')
    plot(minnowList(3).historicalPosition(:,1), minnowList(3).historicalPosition(:,2),'g-')
    plot(minnowList(4).historicalPosition(:,1), minnowList(4).historicalPosition(:,2),'k-')
    plot(minnowList(5).historicalPosition(:,1), minnowList(5).historicalPosition(:,2),'c-')
    plot(minnowList(6).historicalPosition(:,1), minnowList(6).historicalPosition(:,2),'y-')
    plot(minnowList(7).historicalPosition(:,1), minnowList(7).historicalPosition(:,2),'m-')
    plot(sharkList(1).historicalPosition(:,1), sharkList(1).historicalPosition(:,2),'k-')
    plot(sharkList(2).historicalPosition(:,1), sharkList(2).historicalPosition(:,2),'r-')
    plot(minnowList(1).historicalPosition(ii,1), minnowList(1).historicalPosition(ii,2),'rs','markerfacecolor','r')
    plot(minnowList(2).historicalPosition(ii,1), minnowList(2).historicalPosition(ii,2),'bs','markerfacecolor','b')
    plot(minnowList(3).historicalPosition(ii,1), minnowList(3).historicalPosition(ii,2),'gs','markerfacecolor','g')
    plot(minnowList(4).historicalPosition(ii,1), minnowList(4).historicalPosition(ii,2),'ks','markerfacecolor','k')
    plot(minnowList(5).historicalPosition(ii,1), minnowList(5).historicalPosition(ii,2),'cs','markerfacecolor','c')
    plot(minnowList(6).historicalPosition(ii,1), minnowList(6).historicalPosition(ii,2),'ys','markerfacecolor','y')
    plot(minnowList(7).historicalPosition(ii,1), minnowList(7).historicalPosition(ii,2),'ms','markerfacecolor','m')
    plot(sharkList(1).historicalPosition(ii,1), sharkList(1).historicalPosition(ii,2),'ko','markerfacecolor','k')
    plot(sharkList(2).historicalPosition(ii,1), sharkList(2).historicalPosition(ii,2),'ro','markerfacecolor','r')
    hold off
    xlim(xLimits)
    ylim(yLimits)
    pause(0.05)
    title(ii)
    
end
