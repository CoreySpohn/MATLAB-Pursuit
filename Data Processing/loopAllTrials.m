%% This script will take the position data from the lists provided and 
% output the data as a regular list for easier data analysis

clear
averageDistance = NaN(21,17);
minimumDistance = NaN(21,17);
traveledDistance = NaN(21,17);
xMin =[];
yMin = [];
xTotal =[];
yTotal = [];

for l =1:17
trial = l;

minimumAverageSplit = NaN(21,15);
totalDistanceSplit = NaN(21,15);

    for w =1:21
    replicate =w;

    
    
try
%% Load the proper files based on the trial and replicate designated above
gameName = ['trial', int2str(trial), 'rep', int2str(replicate)]; % use for filename output
folderName = ['Trial',' ', int2str(trial), '\'];

if trial < 7
    filename = [folderName, gameName, '.mat'];
    load(filename)
    robotList = [];
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

if isempty(robotList) == 0
    for i=1:length(robotList)
        % Sort the robots
        if strcmp(robotList(i).role, 'Minnow') == 1
            robotMinnowList = [robotMinnowList, robotList(i)];
        else
            robotSharkList = [robotSharkList, robotList(i)];
        end
    end
end
%% Now that everything is split up get just their position data
humanMinnowPositions = [];
humanSharkPositions = [];
robotMinnowPositions = [];
robotSharkPositions = [];

if isempty(humanMinnowList) == 0
    % The isempty function will return 1 if the list is empty and 0 if the
    % list is not empty, so this just makes sure that the for statement
    % won't return an error because it's length is 0
    for i=1:length(humanMinnowList)
        humanMinnowPositions = [humanMinnowPositions, humanMinnowList(i).historicalPosition];
    end
end

if isempty(humanSharkList) == 0
    for i=1:length(humanSharkList)
        humanSharkPositions = [humanSharkPositions, humanSharkList(i).historicalPosition];
    end
end

if isempty(robotMinnowList) == 0
    for i=1:length(robotMinnowList)
        robotMinnowPositions = [robotMinnowPositions, robotMinnowList(i).historicalPosition];
    end
end

if isempty(robotSharkList) == 0
    for i=1:length(robotSharkList)
        robotSharkPositions = [robotSharkPositions, robotSharkList(i).historicalPosition];
    end
end

% Collect all of the position lists into one list
listOfLists = [];
if isempty(humanMinnowPositions) == 0
    listOfLists = [listOfLists, humanMinnowPositions];
end

if isempty(humanSharkPositions) == 0
    listOfLists = [listOfLists, humanSharkPositions];
end

if isempty(robotMinnowPositions) == 0
    listOfLists = [listOfLists, robotMinnowPositions];
end

if isempty(robotSharkPositions) == 0
    listOfLists = [listOfLists, robotSharkPositions];
end

%% Interpolation for NaN values
% Go 1 by 1 down the line of the different lists
% Doing a 1d cubic spline

fixedPositions = [];

for i=1:size(listOfLists,2)
    vals = listOfLists(:,i);
    interpVals = interp1(vals,1:size(listOfLists,1),'cubic');
    
    fixedPositions = [fixedPositions; interpVals];
end

graphPositions = transpose(fixedPositions);
averageDistance(w,l) = avgDistance(graphPositions);
minimumDistance(w,l) = minDistance(graphPositions);
traveledDistance(w,l) = totDistance(graphPositions);
minimumAverageSplit(w,1:size(graphPositions,2)/2) = minAverageSplit(graphPositions);
totalDistanceSplit(w,1:size(graphPositions,2)/2) = totDistanceSplit(graphPositions);

catch
end
    end
    
    xMin = [xMin l.*ones(1,15)];
    yMin = [yMin mean(minimumAverageSplit,'omitnan')];
    xTotal = [xTotal l.*ones(1,15)];
    yTotal = [yTotal mean(totalDistanceSplit,'omitnan')];
    
end

figure()
bar(mean(averageDistance,'omitnan'))
title('Average Distance for Each Trial')
xlabel('Trial Number')

figure()
bar(mean(minimumDistance,'omitnan'))
title('Minimum Distance for Each Trial')
xlabel('Trial Number')

figure()
plot(xMin,yMin,'*')
    title('Minimum Distance Broken Down By Person')
    xlabel('Trial Number')

figure()
bar(mean(traveledDistance,'omitnan'))
title('Total Distance for Each Trial')
xlabel('Trial Number')

figure()
plot(xTotal,yTotal,'*')
    title('Total Distance Broken Down By Person')
    xlabel('Trial Number')
