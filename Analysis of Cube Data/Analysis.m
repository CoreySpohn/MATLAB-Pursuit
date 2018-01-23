%% This script will be used to read in the data collected in The Cube from the
%  CSV file and then determine how to best sort the data.

format compact

numMinnows = 3;
numSharks = 1;

% Get all of the data in an array called rawData
rawData = csvread('timeData.csv');

% Human Initialization
blueWhale = Human(1, 'Minnow', [0,0]);
tiger = Human(2, 'Minnow', [1.5,0]);
howlerMonkey = Human(3, 'Minnow', [3,0]);

% Robot initialization
cat = Robot(1, 'Minnow', [0,0], 1, 1.5, [-5000, 5000], [-5000, 5000]);

% Create lists for humans and robots so that the objects can be easily
% sorted through
humanList = [blueWhale, tiger, howlerMonkey];
robotList = [cat];

for i=1:size(rawData,1)
    if mod(i,6) == 1
        % This will check when the data should be updated because the qtm
        % software sends a 6x1 vector for each hat
        for j=1:length(humanList)
            % This looks through the data and assigns it to the correct
            % human with newData method which takes the values (x, z ,t)
            xPosition = rawData(i, humanList(j).ID);
            ix = i;
            while isnan(xPosition) == 1
                % As long as the x position is not a NaN value, and there
                % has been a value not NaN the position will be recorded.
                % Otherwise it'll set it to the object's starting position
                ix = ix - 6;
                if ix <= 0
                    xPosition = 0;
                else
                    xPosition = rawData(ix, humanList(j).ID);
                end
            end
            
            zPosition = rawData(i+2, humanList(j).ID);
            iz = i;
            while isnan(zPosition) == 1
                % As long as the z position is not a NaN value, and there
                % has been a value not NaN the position will be recorded.
                % Otherwise it'll set it to the object's starting position
                iz = iz - 6;
                if iz <= 0
                    zPosition = 0;
                else
                    zPosition = rawData(iz, humanList(j).ID);
                end
            end
            
            time = rawData(i,size(rawData,2));
            humanList(j).newData(xPosition, zPosition, time);
        end
        
        % Now update position for the robots
        for k=1:length(robotList)
            xPosition = rawData(i, length(humanList)+robotList(k).ID);
            ix = i;
            while isnan(xPosition) == 1
                % As long as the x position is not a NaN value, and there
                % has been a value not NaN the position will be recorded.
                % Otherwise it'll set it to the object's starting position
                ix = ix - 6;
                if ix <= 0
                    xPosition = 0;
                else
                    xPosition = rawData(ix, robotList(k).ID);
                end
            end
            
            zPosition = rawData(i+2, length(humanList)+robotList(k).ID);
            iz = i;
            while isnan(zPosition) == 1
                % As long as the z position is not a NaN value, and there
                % has been a value not NaN the position will be recorded.
                % Otherwise it'll set it to the object's starting position
                iz = iz - 6;
                if iz <= 0
                    zPosition = 0;
                else
                    zPosition = rawData(iz, robotList(k).ID);
                end
            end
            
            time = rawData(i,size(rawData,2));
            robotList(k).newData(xPosition, zPosition, time);
        end
        
    end
end

%%
fig1 = figure('Position',[10 10 800 800]);
yellowColor = 1/255*[150 150 0];
greyColor = 1/255*[120 120 120];
for ii=1:min(length(humanList(1).position), length(humanList(2).position))
    % Plot lines showing the entire motion
%     plot(humanList(1).position(:,1), humanList(1).position(:,2),'r-'), hold on, grid on
%     plot(humanList(2).position(:,1), humanList(2).position(:,2),'b-')
%     plot(humanList(3).position(:,1), humanList(3).position(:,2),'g-')
%     plot(robotList(1).position(:,1), robotList(1).position(:,2),'k-')
    
    % Plot the point at every interval as a marker to see it in motion
    plot(humanList(1).position(ii,1), humanList(1).position(ii,2),'rs','markerfacecolor','r')
    plot(humanList(2).position(ii,1), humanList(2).position(ii,2),'bs','markerfacecolor','b')
    plot(humanList(3).position(ii,1), humanList(3).position(ii,2),'gs','markerfacecolor','g')
    plot(robotList(1).position(ii,1), robotList(1).position(ii,2),'ko','markerfacecolor','k')
    title(ii)
    xlim([-5000, 5000])
    ylim([-5000, 5000])
    pause(0.001)
    
%     % Saves all of the figures so that they can be used for video making
%     if ii < 10
%         % This is to make all of the figures save with the same number of
%         % digits after the word 'figure' because the ffmpeg script expects
%         % 4 digits
%         num = ['000', int2str(ii)];
%     elseif ii < 100
%         num = ['00', int2str(ii)];
%     elseif ii < 1000
%         num = ['0', int2str(ii)];
%     end
%     figureName = ['Video\figure', num, '.png'];
    hold off
end