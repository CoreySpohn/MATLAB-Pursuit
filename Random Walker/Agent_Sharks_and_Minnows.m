%% This script creates a person that moves in a random direction and we can test the algorithm
xLimits = [0, 40];
yLimits = [0, 40];
minnowSpeed = 1;
sharkSpeed = 1.5;
sharkRange = 2;

n = 100;
startingDirection = [1, 0];

minnowOne = Minnow([0, 1], minnowSpeed, startingDirection, xLimits, yLimits, 1, 1);
minnowTwo = Minnow([0, 2], minnowSpeed, startingDirection, xLimits, yLimits, 0.1, 2);
minnowThree = Minnow([0, 5], minnowSpeed, startingDirection, xLimits, yLimits, .1, 3);
minnowFour = Minnow([0, 7], minnowSpeed, startingDirection, xLimits, yLimits, 1, 4);
minnowFive = Minnow([0, 9], minnowSpeed, startingDirection, xLimits, yLimits, 1, 5);
minnowSix = Minnow([0, 11], minnowSpeed, startingDirection, xLimits, yLimits, 1, 6);
minnowSeven = Minnow([0, 13], minnowSpeed, startingDirection, xLimits, yLimits, 1, 7);

minnowList = [minnowOne, minnowTwo, minnowThree, minnowFour, minnowFive, minnowSix, minnowSeven];

sharkOne = Shark([40, randi([1 15],1)], sharkSpeed, sharkRange, [-1,0], xLimits, yLimits, 1);
sharkTwo = Shark([40, randi([15 30],1)], sharkSpeed, sharkRange, [-1,0], xLimits, yLimits, 2);
% sharkThree = Shark([40, randi([30 40],1)], sharkSpeed, sharkRange, [-1,0], xLimits, yLimits, 3);
sharkList = [sharkOne, sharkTwo];

for i=1:1
    for j=1:length(minnowList)
        % compute the forces for all of the minnows and where they should
        % move next
        minnowList(j).steps = minnowList(j).steps + 1;
        minnowList(j).socialForceStep(minnowList, sharkList);
    end
    
    for jj=1:length(minnowList)
        % This is seperate from the previous loop so that the minnows can
        % all have their forces from the same position. If it was in the
        % same one minnow two would be acted on by minnow one after minnow
        % one had already moved, which would put it at a disadvantage.
        minnowList(jj).currentPosition = minnowList(jj).nextPosition;
    end
    
    for ii=1:length(sharkList)
        %% Make sharks react to the minnows
        sharkList(ii).steps = sharkList(ii).steps + 1;
        if sharkList(ii).markedMinnow ~= 0 && sharkList(ii).allCaught == 0
            % If there is a marked minnow already then pursue it
            sharkList(ii).pursueCurrent(minnowList(sharkList(ii).markedMinnow),minnowList);
        elseif sharkList(ii).allCaught == 0
            sharkList(ii).chooseMinnow2(minnowList);
            if sharkList(ii).allCaught == 1
                for ij=1:length(sharkList)
                    % Tell all sharks that the minnows have been caught
                    % and which step it happened on
                    if length(sharkList(ij).historicalPosition) < sharkList(ii).historicalPosition
                        sharkList(ij).historicalPosition = [sharkList(ij).historicalPosition;sharkList(ij).position];
                    end
                    sharkList(ij).allCaught = 1;
                end
            
            else
                sharkList(ii).pursueCurrent(minnowList(sharkList(ii).markedMinnow),minnowList);
            end
        end
        
    end
    
end

%% Plot everything

fig1 = figure('Position',[10 10 800 800]);
yellowColor = 1/255*[150 150 0];
greyColor = 1/255*[120 120 120];
for ii=1:min(length(sharkList(1).historicalPosition),length(sharkList(2).historicalPosition))
    % Plot lines showing the entire motion
    plot(minnowList(1).historicalPosition(:,1), minnowList(1).historicalPosition(:,2),'r-'), hold on, grid on
    plot(minnowList(2).historicalPosition(:,1), minnowList(2).historicalPosition(:,2),'b-')
    plot(minnowList(3).historicalPosition(:,1), minnowList(3).historicalPosition(:,2),'g-')
    plot(minnowList(4).historicalPosition(:,1), minnowList(4).historicalPosition(:,2),'k-')
    plot(minnowList(5).historicalPosition(:,1), minnowList(5).historicalPosition(:,2),'c-')
    plot(minnowList(6).historicalPosition(:,1), minnowList(6).historicalPosition(:,2), 'Color', yellowColor)
    plot(minnowList(7).historicalPosition(:,1), minnowList(7).historicalPosition(:,2),'m-')
    plot(sharkList(1).historicalPosition(:,1), sharkList(1).historicalPosition(:,2),'k-')
    plot(sharkList(2).historicalPosition(:,1), sharkList(2).historicalPosition(:,2),'Color', greyColor)
%     plot(sharkList(3).historicalPosition(:,1), sharkList(3).historicalPosition(:,2),'b-')
    
    % Plot the point at every interval as a marker to see it in motion
    plot(minnowList(1).historicalPosition(ii,1), minnowList(1).historicalPosition(ii,2),'rs','markerfacecolor','r')
    plot(minnowList(2).historicalPosition(ii,1), minnowList(2).historicalPosition(ii,2),'bs','markerfacecolor','b')
    plot(minnowList(3).historicalPosition(ii,1), minnowList(3).historicalPosition(ii,2),'gs','markerfacecolor','g')
    plot(minnowList(4).historicalPosition(ii,1), minnowList(4).historicalPosition(ii,2),'ks','markerfacecolor','k')
    plot(minnowList(5).historicalPosition(ii,1), minnowList(5).historicalPosition(ii,2),'cs','markerfacecolor','c')
    plot(minnowList(6).historicalPosition(ii,1), minnowList(6).historicalPosition(ii,2),'s','Color',yellowColor,'markerfacecolor', yellowColor)
    plot(minnowList(7).historicalPosition(ii,1), minnowList(7).historicalPosition(ii,2),'ms','markerfacecolor','m')
    plot(sharkList(1).historicalPosition(ii,1), sharkList(1).historicalPosition(ii,2),'ko','markerfacecolor','k')
    plot(sharkList(2).historicalPosition(ii,1), sharkList(2).historicalPosition(ii,2),'o','Color',greyColor,'markerfacecolor',greyColor)
%     plot(sharkList(3).historicalPosition(ii,1), sharkList(3).historicalPosition(ii,2),'bo','markerfacecolor','b')
    title(ii)
    xlim(xLimits)
    ylim(yLimits)
    pause(0.05)
    
    % Saves all of the figures so that they can be used for video making
    if ii < 10
        % This is to make all of the figures save with the same number of
        % digits after the word 'figure' because the ffmpeg script expects
        % 4 digits
        num = ['000', int2str(ii)];
    elseif ii < 100
        num = ['00', int2str(ii)];
    elseif ii < 1000
        num = ['0', int2str(ii)];
    end
    figureName = ['Video\figure', num, '.png'];
%     print(fig1, figureName)
%     saveas(fig1, figureName)
    hold off
end