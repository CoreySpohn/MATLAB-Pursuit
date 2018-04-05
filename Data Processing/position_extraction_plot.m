%% This script will take the position data from the lists provided and 
% output the data as a regular list for easier data analysis

clear


trial = 16;
replicate = 5;

%% Load the proper files based on the trial and replicate designated above
gameName = ['trial', int2str(trial), 'rep', int2str(replicate)]; % use for filename output
folderName = ['Trial',' ', int2str(trial), '\'];

if trial < 7
    filename = [folderName, gameName, '.mat'];
    load(filename)
else
    humanListFilename = [folderName, gameName, 'humans.mat'];
    robotListFilename = [folderName, gameName, 'robots.mat'];
    load(humanListFilename)
    load(robotListFilename)
end

%% Sort the raw human and robot lists into minnows and sharks
humanMinnowList = [];
humanSharkList = [];
robotMinnowList = [];
robotSharkList = [];

for i=1:length(humanList)
    % Sort the humans
    if strcmp(humanList(i).role, 'Minnow') == 1
        humanMinnowList = [humanMinnowList, humanList(i)];
    else
        humanSharkList = [humanSharkList, humanList(i)];
    end
end

for i=1:length(robotList)
    % Sort the robots
    if strcmp(robotList(i).role, 'Minnow') == 1
        robotMinnowList = [robotMinnowList, robotList(i)];
    else
        robotSharkList = [robotSharkList, robotList(i)];
    end
end

%% Now that everything is split up get just their position data
humanMinnowPositions = [];
humanSharkPositions = [];
robotMinnowPositions = [];
robotSharkPositions = [];

graphHMinnow = [];
graphHShark = [];
graphRMinnow = [];
graphRShark = [];

if isempty(humanMinnowList) == 0
    % The isempty function will return 1 if the list is empty and 0 if the
    % list is not empty, so this just makes sure that the for statement
    % won't return an error because it's length is 0
    for i=1:length(humanMinnowList)
        humanMinnowPositions = [humanMinnowPositions, humanMinnowList(i).historicalPosition];
        graphHMinnow = [graphHMinnow, strcat('humanMinnow',int2str(i))];
    end
end

if isempty(humanSharkList) == 0
    for i=1:length(humanSharkList)
        humanSharkPositions = [humanSharkPositions, humanSharkList(i).historicalPosition];
        graphHShark = [graphHShark, strcat('humanShark',int2str(i))];
    end
end

if isempty(robotMinnowList) == 0
    for i=1:length(robotMinnowList)
        robotMinnowPositions = [robotMinnowPositions, robotMinnowList(i).historicalPosition];
        graphRMinnow = [graphRMinnow, strcat('robotMinnow',int2str(i))];
    end
end

if isempty(robotSharkList) == 0
    for i=1:length(robotSharkList)
        robotSharkPositions = [robotSharkPositions, robotSharkList(i).historicalPosition];
        graphRShark = [graphRShark, strcat('robotShark',int2str(i))];
    end
end



graphPositions = [humanMinnowPositions, humanSharkPositions, robotMinnowPositions,robotSharkPositions];
graphLabel = [graphHMinnow, graphHShark, graphRMinnow, graphRShark];

figure('units','normalized','outerposition',[0 0 1 1])

for i = 1:2:size(graphPositions,2)
    plot(graphPositions(:,i),graphPositions(:,i+1),'-*')
    hold on
end

legend(graphLabel,'Orientation','horizontal')
ylim([-4000 2500])