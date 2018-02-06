%% This is the script to run the full game
clear all
clc

% Important constants
qtm=QMC('QMC_conf.txt');
timeIncrement = .01;  % Number of seconds between measurements
seconds = 60;
sharkRange = 300;

%% xBee stuff

%{
try
    fclose(xBee);
    delete(xBee);
    clear xBee;
    fprintf('Old MATLAB serial port needed to be closed first\n');
catch
end

xBee = serial('COM4', 'BaudRate', 115200, 'Parity', 'none', 'DataBits', 8);
fopen(xBee);


format compact;
fullData = [];
for i=1:seconds/timeIncrement
    [data3DOF data6DOF] = QMC(qtm, 'frameinfo');
    data6DOF  % Print the 6 degree of freedom data
    fullData = [fullData;data6DOF]; % Make a giant array with all of the data
    pause(timeIncrement)  % Wait the indicated period of time until the next measurement
end
%}

gameBoundariesX = [-3.8e03, 3e03];
gameBoundariesY = [-3.3e03, 2e03];

trial = 4;
replicate = 1;
gameName = "trial" + int2str(trial) + "rep" + int2str(replicate); % use for filename output

if trial < 7
    robotMinnows = 0;
    robotSharks = 0;
    if mod(trial, 2) == 1
        humanMinnows = 10;
    else
        humanMinnows = 5;
    end
    if trial < 3
        humanSharks = 3;
    elseif trial < 5
        humanSharks = 2;
    else
        humanSharks = 1;
    end
elseif trial < 13
    robotMinnows = 0;
    humanSharks = 0;
    if mod(trial, 2) == 1
        humanMinnows = 10;
    else
        humanMinnows = 5;
    end
    if trial < 9
        robotSharks = 3;
    elseif trial < 11
        robotSharks = 2;
    else
        robotSharks = 1;
    end
else
    robotSharks = 0;
    robotMinnows = 2;
    if mod(trial, 2) == 1
        humanMinnows = 8;
    else
        humanMinnows = 3;
    end
    if trial < 15
        humanSharks = 3;
    elseif trial < 17
        humanSharks = 2;
    else
        humanSharks = 1;
    end
end

%% Object Initialization
% Human(ID, role, pos, name)
% Robot(ID, role, speed, range, xLimits, yLimits, name)

% Minnows
if humanMinnows == 10
    blueWhale = Human(1, 'Minnow', 'Blue Whale', gameBoundariesX, gameBoundariesY);
    chimpanzee = Human(2, 'Minnow', 'Chimpanzee', gameBoundariesX, gameBoundariesY);
    tiger = Human(3, 'Minnow', 'Tiger', gameBoundariesX, gameBoundariesY);
    cat = Human(4, 'Minnow', 'Cat', gameBoundariesX, gameBoundariesY);
    lion = Human(5, 'Minnow', 'Lion', gameBoundariesX, gameBoundariesY);
    seal = Human(6, 'Minnow', 'Seal', gameBoundariesX, gameBoundariesY);
    squirrel = Human(7, 'Minnow', 'Squirrel', gameBoundariesX, gameBoundariesY);
    gorilla = Human(8, 'Minnow', 'Gorilla', gameBoundariesX, gameBoundariesY);
    skunk = Human(9, 'Minnow', 'Skunk', gameBoundariesX, gameBoundariesY);
    germanShepherd = Human(10, 'Minnow', 'German Shepherd', gameBoundariesX, gameBoundariesY);
elseif humanMinnows == 8
    blueWhale = Human(1, 'Minnow', 'Blue Whale', gameBoundariesX, gameBoundariesY);
    chimpanzee = Human(2, 'Minnow', 'Chimpanzee', gameBoundariesX, gameBoundariesY);
    tiger = Human(3, 'Minnow', 'Tiger', gameBoundariesX, gameBoundariesY);
    cat = Human(4, 'Minnow', 'Cat', gameBoundariesX, gameBoundariesY);
    lion = Human(5, 'Minnow', 'Lion', gameBoundariesX, gameBoundariesY);
    seal = Human(6, 'Minnow', 'Seal', gameBoundariesX, gameBoundariesY);
    squirrel = Human(7, 'Minnow', 'Squirrel', gameBoundariesX, gameBoundariesY);
    gorilla = Human(8, 'Minnow', 'Gorilla', gameBoundariesX, gameBoundariesY);
elseif humanMinnows == 5
    blueWhale = Human(1, 'Minnow', 'Blue Whale', gameBoundariesX, gameBoundariesY);
    chimpanzee = Human(2, 'Minnow', 'Chimpanzee', gameBoundariesX, gameBoundariesY);
    tiger = Human(3, 'Minnow', 'Tiger', gameBoundariesX, gameBoundariesY);
    cat = Human(4, 'Minnow', 'Cat', gameBoundariesX, gameBoundariesY);
    lion = Human(5, 'Minnow', 'Lion', gameBoundariesX, gameBoundariesY);
elseif humanMinnows == 3
    blueWhale = Human(1, 'Minnow', 'Blue Whale', gameBoundariesX, gameBoundariesY);
    chimpanzee = Human(2, 'Minnow', 'Chimpanzee', gameBoundariesX, gameBoundariesY);
    tiger = Human(3, 'Minnow', 'Tiger', gameBoundariesX, gameBoundariesY);
end

if robotMinnows == 2
    skunk = Robot(9, 'Minnow', 499.9, sharkRange, gameBoundariesX, gameBoundariesY, 'Skunk');
    germanShepherd = Robot(10, 'Minnow', 499.9, sharkRange, gameBoundariesX, gameBoundariesY, 'German Shepherd');
end

% Sharks
if humanSharks == 3
    horse = Human(11, 'Shark', 'Horse', gameBoundariesX, gameBoundariesY);
    giraffe = Human(12, 'Shark', 'Giraffe', gameBoundariesX, gameBoundariesY);
    otter = Human(13, 'Shark', 'Otter', gameBoundariesX, gameBoundariesY);
elseif humanSharks == 2
    horse = Human(11, 'Shark', 'Horse', gameBoundariesX, gameBoundariesY);
    giraffe = Human(12, 'Shark', 'Giraffe', gameBoundariesX, gameBoundariesY);
elseif humanSharks == 1
    horse = Human(11, 'Shark', 'Horse', gameBoundariesX, gameBoundariesY);
end

if robotSharks == 3
    horse = Robot(11, 'Shark', 499.9, sharkRange, gameBoundariesX, gameBoundariesY, 'Horse');
    giraffe = Robot(12, 'Shark', 499.9, sharkRange, gameBoundariesX, gameBoundariesY, 'Giraffe');
    otter = Robot(13, 'Shark', 499.9, sharkRange, gameBoundariesX, gameBoundariesY, 'Otter');
elseif robotSharks == 2
    horse = Robot(11, 'Shark', 499.9, sharkRange, gameBoundariesX, gameBoundariesY, 'Horse');
    giraffe = Robot(12, 'Shark', 499.9, sharkRange, gameBoundariesX, gameBoundariesY, 'Giraffe');
elseif robotSharks == 1
    horse = Robot(11, 'Shark', 499.9, sharkRange, gameBoundariesX, gameBoundariesY, 'Horse');
end

%% Create the correct lists filled with the robots and humans based on the trial number
humanMinnowList = [];
humanSharkList = [];
robotMinnowList = [];
robotSharkList = [];
minnowList = [];
robotList = [];

if trial < 7
    robotMinnows = 0;
    robotSharks = 0;
    if mod(trial, 2) == 1
        humanMinnows = 10;
        humanMinnowList = [blueWhale, chimpanzee, tiger, cat, lion, seal, squirrel, gorilla, skunk, germanShepherd];
    else
        humanMinnows = 5;
        humanMinnowList = [blueWhale, chimpanzee, tiger, cat, lion];
    end
    if trial < 3
        humanSharks = 3;
        humanSharkList = [horse, giraffe, otter];
    elseif trial < 5
        humanSharks = 2;
        humanSharkList = [horse, giraffe];
    else
        humanSharks = 1;
        humanSharkList = [horse];
    end
elseif trial < 13
    robotMinnows = 0;
    humanSharks = 0;
    if mod(trial, 2) == 1
        humanMinnows = 10;
        humanMinnowList = [blueWhale, chimpanzee, tiger, cat, lion, seal, squirrel, gorilla, skunk, germanShepherd];
    else
        humanMinnows = 5;
        humanMinnowList = [blueWhale, chimpanzee, tiger, cat, lion];
    end
    if trial < 9
        robotSharks = 3;
        robotSharkList = [horse, giraffe, otter];
    elseif trial < 11
        robotSharks = 2;
        robotSharkList = [horse, giraffe];
    else
        robotSharks = 1;
        robotSharkList = [horse];
    end
    robotList = robotSharkList;
else
    robotSharks = 0;
    robotMinnows = 2;
    robotMinnowList = [skunk, germanShepherd];
    
    if mod(trial, 2) == 1
        humanMinnows = 8;
        humanMinnowList = [blueWhale, chimpanzee, tiger, cat, lion, seal, squirrel, gorilla];
    else
        humanMinnows = 3;
        humanMinnowList = [blueWhale, chimpanzee, tiger];
    end
    if trial < 15
        humanSharks = 3;
        humanSharkList = [horse, giraffe, otter];
    elseif trial < 17
        humanSharks = 2;
        humanSharkList = [horse, giraffe];
    else
        humanSharks = 1;
        humanSharkList = [horse];
    end
    robotList = robotMinnowList;
end
goalPoint = 0.95 * gameBoundariesX(1);

%% GAME START

% This loop encompasses the entire game, the basics are each game has a set
% number of rounds, in which the minnows run from one side to the other.
% Then during the round each person on the human and robot lists have their
% position updated from the QTM data.
allFinished = 0;
while allFinished == 0
    % Get data from QTM
    [data3DOF, data6DOF] = QMC(qtm, 'frameinfo');
    data6DOF
    % Update the positions
    if isempty(humanMinnowList) == 0
        for i=1:length(humanMinnowList)
            % Note that this also checks to see if they are a minnow and
            % have finished
            humanMinnowList(i).newData(data6DOF, goalPoint);
        end
    end
    if isempty(robotMinnowList) == 0
        % Update the position of all robot minnows
        for i=1:length(robotMinnowList)
            robotMinnowList(i).newData(data6DOF, goalPoint);
        end
    end
    if isempty(humanSharkList) == 0
        for i=1:length(humanSharkList)
            % Update any human shark
            humanSharkList(i).newData(data6DOF, goalPoint);
        end
    end
    if isempty(robotSharkList) == 0
        % Update the position of all robot sharks
        for i=1:length(robotSharkList)
            robotSharkList(i).newData(data6DOF);
        end
    end
    humanList = [humanMinnowList, humanSharkList];
    robotList = [robotMinnowList, robotSharkList];
    %{
    finishedMinnows = 0;
    if mod(trial, 2) == 1
        if isempty(robotMinnowList) == 1
            for i=1:10
                finishedMinnows = finishedMinnows + humanMinnowList(i).finished;
            end
        else
            for i=1:8
                finishedMinnows = finishedMinnows + humanMinnowList(i).finished;
            end
            finishedMinnows = finishedMinnows + robotMinnowList(1).finished + robotMinnowList(2).finished;
        end
        if finishedMinnows == 10
            allFinished = 1;
        end
    else
        if isempty(robotMinnowList) == 1
            for i=1:5
                finishedMinnows = finishedMinnows + humanMinnowList(i).finished;
            end
        else
            for i=1:3
                finishedMinnows = finishedMinnows + humanMinnowList(i).finished;
            end
            finishedMinnows = finishedMinnows + robotMinnowList(1).finished + robotMinnowList(2).finished;
        end
        if finishedMinnows == 5
            allFinished = 1;
        end
    end
    
    
    % Determine the appropriate velocities for each of the robots, save
    % them in the object classes to send over xBee
    if (7 <= trial) && (trial < 13)
        for i=1:length(robotSharkList)
            if robotSharkList(i).markedMinnow == 0
                robotSharkList(i).chooseMinnow(humanMinnowList);
            end
            robotSharkList(i).sharkMove(humanMinnowList(robotSharkList(i).markedMinnow), humanMinnowList);
        end
    elseif (13 <= trial)
        for i=1:length(robotMinnowList)
            robotMinnowList(i).minnowMove(humanMinnowList, humanSharkList);
        end
    end
    
    % Check to see if any of the minnows were caught
    
    for i=1:length(robotSharkList)
        for j=1:length(humanMinnowList)
            if humanMinnowList(j).finished == 0
                % For minnows that aren't finished check if they got caught
                distance = norm(sharkList(i).position-humanMinnowList(j).position);
                if distance <= robotSharkList(i).range
                    humanMinnowList(j).finished = 1;
                    fprintf('%s was caught by %s', humanMinnowList(j).name, robotSharkList(j).name)
                end
            end
        end
    end
    
    % Send the data
    velocities = [];
    
    for i=1:length(robotMinnowList)
        velocities = [velocities; robotList(i).velocity];
    end
    fprintf('again')
    if isempty(robotList) == 0
        break
    elseif length(robotList) == 1
        velocityString = num2str(velocities(1,1)) + ' ' + num2str(velocities(1,2));
        fprintf(xBee,'%s',velocityString);
    elseif length(robotList) == 2
        velocityString = num2str(velocities(1,1)) + ' ' + num2str(velocities(1,2)) + ' ' + num2str(velocities(2,1)) + ' ' + num2str(velocities(2,1));
        fprintf(xBee,'%s',velocityString);
    elseif length(robotList) == 3
        velocityString = num2str(velocities(1,1)) + ' ' + num2str(velocities(1,2)) + ' ' + num2str(velocities(2,1)) + ' ' + num2str(velocities(2,1)) + ' robot3' + num2str(velocities(3,1)) + ' ' + num2str(velocities(3,1));
        fprintf(xBee,'%s',velocityString);
    end
    %}
    
end

%% Save data after the trial is complete
%{
positionData = [];
nameAndRoleData = [];
for i = 1:length(humanMinnowList)
    positionData = [positionData; humanMinnowList(i).historicalPosition];
    nameAndRoleData = [nameAndRoleData; humanMinnowList(i).name];
end

for i = 1:length(humanSharkList)
    positionData = [positionData;humanSharkList(i).historicalPosition];
    nameAndRoleData = [nameAndRoleData; humanSharkList(i).name];
end

for i = 1:length(robotMinnowList)
    positionData = [positionData;robotMinnowList(i).historicalPosition];
    nameAndRoleData = [nameAndRoleData; robotMinnowList(i).name];
end

for i = 1:length(robotSharkList)
    positionData = [positionData;robotSharkList(i).historicalPosition];
    nameAndRoleData = [nameAndRoleData; robotSharkList(i).name];
end

filenameNames = gameName + 'names.csv';
filenamePositions = gameName + 'positions.csv';
csvwrite(filenameNames, nameAndRoleData)
csvwrite(filnamePositions,positionData)
%}

%close serial port
% fclose(xBee);
% delete(xBee);
% clear arduino;
% fprintf('Matlab serial port was closed\n');
% fprintf('END\n');

QMC(qtm,'disconnect')
