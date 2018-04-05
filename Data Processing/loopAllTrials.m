%This script loops through all the replicates for each trial in the
%experiment

% vector size is 21*17 because there are at most 21 replicates and at most 17
% trials
clear
averageDistance = NaN(21,17);
minimumDistance = NaN(21,17);
traveledDistance = NaN(21,17);
xMin =[];
yMin = [];
xTotal =[];
yTotal = [];
xAverage =[];
yAverage = [];
xVel = [];
yVel = [];
xTime =[];
yTime =[];
yMinSpecies = [];
yTotalSpecies = [];
yVelSpecies = [];
yTimeSpecies = [];
yMinStd = [];
yTotalStd = [];
yVelStd = [];
yTimeStd = [];

%looping through every trial
for l =1:17
trial = l;

%these variables are used to split up data analysis by person in each trial
%The dimension is 21*15 because at most 21 replicates and 15 people in a
%trial
minimumAverageSplit = NaN(21,15);
totalDistanceSplit = NaN(21,15);
avgVelSplit = NaN(21,15);
avgTSplit = NaN(21,15);

%loop through every replicate
    for w =1:21
    replicate =w;

    
%some replicates have an error so the try catch statement ignores replicates with errors
%the code to load a file in is copied from the position_extraction script
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

%Calling function for data anlysis and storing function return values 
minimumAverageSplit(w,1:size(graphPositions,2)/2) = minAverageSplit(graphPositions);
totalDistanceSplit(w,1:size(graphPositions,2)/2) = totDistanceSplit(graphPositions);
avgVelSplit(w,1:size(graphPositions,2)/2) = avgVelocitySplit(graphPositions);
avgTSplit(w,1:size(graphPositions,2)/2) = avgTimeSplit(graphPositions);

catch
end
    end
    
    %The l values are trial numbers, this breaks down the number of each
    %species for the different trial numbers
    if l == 3
        hShark = 2;
        hMinnow = 10;
        rShark = 0;
        rMinnow =0;
    elseif l==4
        hShark = 2;
        hMinnow = 5;
        rShark = 0;
        rMinnow =0;
    elseif l==7
        hShark = 0;
        hMinnow = 10;
        rShark = 3;
        rMinnow =0;
    elseif l==8
        hShark = 0;
        hMinnow = 5;
        rShark = 3;
        rMinnow =0;
    elseif l==15
        hShark = 2;
        hMinnow = 8;
        rShark = 0;
        rMinnow =2;
    elseif l==16
        hShark = 2;
        hMinnow = 3;
        rShark = 0;
        rMinnow =2;
    elseif l==17
        hShark = 1;
        hMinnow = 8;
        rShark = 0;
        rMinnow =2;
    else
        hShark = 2;
        hMinnow = 10;
        rShark = 0;
        rMinnow =0;
    end
    
    %intermediate calculation
    a = mean(minimumAverageSplit,'omitnan');
    b = mean(totalDistanceSplit,'omitnan');
    c = mean(avgVelSplit,'omitnan');
    d = mean(avgTSplit,'omitnan');
    
    %the l values are trial numbers we had data for
    if l==3 || l==4 || l==7 || l==8 ||l==15 ||l==16 ||l==17
    
    %bar plot values, this averages participants of the same species, for
    %example all human minnow values are averaged together
    yMinSpecies = [yMinSpecies ;mean(a(1:hMinnow),'omitnan') mean(a(hMinnow+1:hShark+hMinnow),'omitnan') mean(a(hShark+hMinnow+1:hShark+hMinnow+rMinnow),'omitnan') mean(a(rMinnow+hShark+hMinnow+1:hShark+hMinnow+rMinnow+rShark),'omitnan') NaN NaN NaN];
    yTotalSpecies = [yTotalSpecies ; mean(b(1:hMinnow),'omitnan') mean(b(hMinnow+1:hShark+hMinnow),'omitnan') mean(b(hShark+hMinnow+1:hShark+hMinnow+rMinnow),'omitnan') mean(b(rMinnow+hShark+hMinnow+1:hShark+hMinnow+rMinnow+rShark),'omitnan') NaN NaN NaN];
    yVelSpecies = [yVelSpecies ;mean(c(1:hMinnow),'omitnan') mean(c(hMinnow+1:hShark+hMinnow),'omitnan') mean(c(hShark+hMinnow+1:hShark+hMinnow+rMinnow),'omitnan') mean(c(rMinnow+hShark+hMinnow+1:hShark+hMinnow+rMinnow+rShark),'omitnan') NaN NaN NaN];
    yTimeSpecies = [yTimeSpecies ; mean(d(1:hMinnow),'omitnan') mean(d(hMinnow+1:hShark+hMinnow),'omitnan') mean(d(hShark+hMinnow+1:hShark+hMinnow+rMinnow),'omitnan') mean(d(rMinnow+hShark+hMinnow+1:hShark+hMinnow+rMinnow+rShark),'omitnan') NaN NaN NaN];
    
    %standard deviation for the replicates in each trial
    yMinStd = [yMinStd ; std(mean(minimumAverageSplit(:,1:hMinnow),2,'omitnan'),'omitnan') std(mean(minimumAverageSplit(:,1+hMinnow:hMinnow+hShark),2,'omitnan'),'omitnan') std(mean(minimumAverageSplit(:,1+hMinnow+hShark:hMinnow+hShark+rMinnow),2,'omitnan'),'omitnan') std(mean(minimumAverageSplit(:,1+hMinnow+hShark+rMinnow:hMinnow+hShark+rMinnow+rShark),2,'omitnan'),'omitnan') NaN NaN NaN];
    yTotalStd = [yTotalStd ;std(mean(totalDistanceSplit(:,1:hMinnow),2,'omitnan'),'omitnan') std(mean(totalDistanceSplit(:,1+hMinnow:hMinnow+hShark),2,'omitnan'),'omitnan') std(mean(totalDistanceSplit(:,1+hMinnow+hShark:hMinnow+hShark+rMinnow),2,'omitnan'),'omitnan') std(mean(totalDistanceSplit(:,1+hMinnow+hShark+rMinnow:hMinnow+hShark+rMinnow+rShark),2,'omitnan'),'omitnan') NaN NaN NaN];
    yVelStd = [yVelStd ;std(mean(avgVelSplit(:,1:hMinnow),2,'omitnan'),'omitnan') std(mean(avgVelSplit(:,1+hMinnow:hMinnow+hShark),2,'omitnan'),'omitnan') std(mean(avgVelSplit(:,1+hMinnow+hShark:hMinnow+hShark+rMinnow),2,'omitnan'),'omitnan') std(mean(avgVelSplit(:,1+hMinnow+hShark+rMinnow:hMinnow+hShark+rMinnow+rShark),2,'omitnan'),'omitnan') NaN NaN NaN];
    yTimeStd = [yTimeStd ; std(mean(avgTSplit(:,1:hMinnow),2,'omitnan'),'omitnan') std(mean(avgTSplit(:,1+hMinnow:hMinnow+hShark),2,'omitnan'),'omitnan') std(mean(avgTSplit(:,1+hMinnow+hShark:hMinnow+hShark+rMinnow),2,'omitnan'),'omitnan') std(mean(avgTSplit(:,1+hMinnow+hShark+rMinnow:hMinnow+hShark+rMinnow+rShark),2,'omitnan'),'omitnan') NaN NaN NaN];
    
    end
    
end

descr = {'Trial Descriptions:';
         '       |A   |B  |C |D |E|F |G';
         '        --------------------------';
         'Hmn|10 |5  |10|5 |8 |3 |8';
         'Mnw|       ';
         '                           ';
         'Hmn|2   |2  |0  |0 |2 |2 |1 ';
         'Srk  |';
         '                         ';
         'Rbt  |0   |0  |0  |0 |2 |2 |2 ';
         'Mnw|';
         '                         ';
         'Rbt  |0   |0  |3  |3 |0 |0 |0 ';
         'Srk  |';};    

%plotting the data analysis

%this plots the minimum distance bar plot with error bars, the error bars are added in the two
%for loops
figure()
h= bar(yMinSpecies)
set(gca,'XTickLabel', {'A','B','C','D','E','F','G'})
yMinStd = transpose(yMinStd);
for k1 = 1:size(h,2)
    ctr(k1,:) = bsxfun(@plus, h(k1).XData, [h(k1).XOffset]');             % Centres Of Bar Groups
    ydt(k1,:) = h(k1).YData;                                                 % Y-Data Of Bar Groups
end
hold on
for k1 = 1:size(h,2)
    errorbar(ctr(k1,:), ydt(k1,:), yMinStd(k1,:), '.r')
end
hold off

    title('Minimum Distance Broken Down By Species')
    xlabel('Trial')
colormap(summer(4));
grid on
l = cell(1,4);
l{1}='Human Minnow'; l{2}='Human Shark'; l{3}='Robot Minnow'; l{4}='Robot Shark';    
legend(h,l,'Location','bestoutside');
text(7.8,1100,descr)
%dat = [10, 2, 0, 0; 5, 2, 0, 0; 10, 0, 0, 3; 5, 0, 0, 3; 8, 2, 2, 0; 3, 2, 2, 0; 8, 1, 2, 0];
%cnames = {'Human Minnow','Human Shark','Robot Minnow','Robot Shark'};
%rnames = {'Aa','Ba','Ca','Da','Ea','Fa','Ga'};
%t = uitable(h);
%t.data = dat;
%t.ColumnName = cnames;

%this plots the total distance bar plot with error bars, the error bars are added in the two
%for loops 
figure()
p=bar(yTotalSpecies)
set(gca,'XTickLabel', {'A','B','C','D','E','F','G'})
yTotalStd = transpose(yTotalStd);
for k1 = 1:size(p,2)
    ctr(k1,:) = bsxfun(@plus, p(k1).XData, [p(k1).XOffset]');             % Centres Of Bar Groups
    ydt(k1,:) = p(k1).YData;                                                 % Y-Data Of Bar Groups
end
hold on
for k1 = 1:size(p,2)
    errorbar(ctr(k1,:), ydt(k1,:), yTotalStd(k1,:), '.r')
end
hold off

title('Total Distance Broken Down By Species')
    xlabel('Trial')
colormap(summer(4));
grid on
l = cell(1,4);
l{1}='Human Minnow'; l{2}='Human Shark'; l{3}='Robot Minnow'; l{4}='Robot Shark';    
legend(p,l,'Location','bestoutside');
text(7.8,9000,descr)

%this plots the velocity bar plot with error bars, the error bars are added in the two
%for loops 
figure()
y=bar(yVelSpecies)
set(gca,'XTickLabel', {'A','B','C','D','E','F','G'})
yVelStd = transpose(yVelStd);
for k1 = 1:size(y,2)
    ctr(k1,:) = bsxfun(@plus, y(k1).XData, [y(k1).XOffset]');             % Centres Of Bar Groups
    ydt(k1,:) = y(k1).YData;                                                 % Y-Data Of Bar Groups
end
hold on
for k1 = 1:size(y,2)
    errorbar(ctr(k1,:), ydt(k1,:), yVelStd(k1,:), '.r')
end
hold off

    title('Average Velocity Broken Down By Species')
    xlabel('Trial') 
    colormap(summer(4));
grid on
l = cell(1,4);
l{1}='Human Minnow'; l{2}='Human Shark'; l{3}='Robot Minnow'; l{4}='Robot Shark';    
legend(y,l,'Location','bestoutside');
text(7.8,30,descr)

%this plots the total time bar plot with error bars, the error bars are added in the two
%for loops
figure()
u=bar(yTimeSpecies)
set(gca,'XTickLabel', {'A','B','C','D','E','F','G'})
yTimeStd = transpose(yTimeStd);
for k1 = 1:size(u,2)
    ctr(k1,:) = bsxfun(@plus, u(k1).XData, [u(k1).XOffset]');             % Centres Of Bar Groups
    ydt(k1,:) = u(k1).YData;                                                 % Y-Data Of Bar Groups
end
hold on
for k1 = 1:size(u,2)
    errorbar(ctr(k1,:), ydt(k1,:), yTimeStd(k1,:), '.r')
end
hold off

    title('Average Time Broken Down By Species')
    xlabel('Trial')     
    colormap(summer(4));
grid on
l = cell(1,4);
l{1}='Human Minnow'; l{2}='Human Shark'; l{3}='Robot Minnow'; l{4}='Robot Shark';    
legend(u,l,'Location','bestoutside');
text(7.8,175,descr)