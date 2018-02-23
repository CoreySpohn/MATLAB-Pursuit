%% This script will take the position data from the lists provided and 
% output the data as a regular list for easier data analysis

clear


trial = 15;
replicate = 1;

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

figure()

for i = 1:2:size(graphPositions,2)
    plot(graphPositions(:,i),graphPositions(:,i+1),'-*')
    hold on
end
ylim([-4000 4000])
xlim([-4000 4000])
%{
for j=1:2:size(humanSharkPositions,2)
    % j indicates the column
    % Go by twos because the coordinates are sorted as x1|y1|x2|y2|x3| etc
    % so you can use i for x and i+1 for y
    
    for i=1:size(humanSharkPositions,1)
        % i indicates the row
        if isnan(humanSharkPositions(i, j)) == 1 || isnan(humanSharkPositions(i,j+1)) == 1
            % if either the x or y position values are NaN then start this
            nanValues = 0; % This is used to count the number of nan values to know the range for the spline interpolation
            
            while isnan(humanSharkPositions(i+nanValues,j)) == 1 || isnan(humanSharkPositions(i+nanValues,j+1)) == 1
                nanValues = nanValues + 1;
                
                if (i+nanValues) >= size(humanSharkPositions,1)
                    % This signifies that it's the last entry, used for
                    % debugging
                    fprintf('Row: %i NaNs: %i\n', i,nanValues)
                    break
                end
                
            end
            % Now we have the number of consecutive NaN values and can use
            % that to determine the range of the spline function
            % We need to get x and y values on either side of the NaNs
            
            if i == 1
                break
            else
                xVals = [humanSharkPositions(i-10,j), humanSharkPositions(i-5,j), humanSharkPositions(i-1,j), humanSharkPositions(i+nanValues+1,j), humanSharkPositions(i+nanValues+5,j), humanSharkPositions(i+nanValues+10,j)];
                yVals = [humanSharkPositions(i-10,j+1), humanSharkPositions(i-5,j+1), humanSharkPositions(i-1,j+1), humanSharkPositions(i+nanValues+1,j+1), humanSharkPositions(i+nanValues+5,j+1), humanSharkPositions(i+nanValues+10,j+1)];
                interval = [];
                spline(xVals,yVals);
            end
            
            
        end
    end
end
%}
