%% This is the script to run the full game

% Important constants
qtm=QMC('QMC_conf.txt');
timeIncrement = .01;  % Number of seconds between measurements

gameBoundariesX = [-5000, 5000];
gameBoundariesY = [-5000, 5000];
sharkStartingLocations = [0,-2500; 0,0; 0,2500];
gameName = 'temp'; % use for filename output

%% Human Initialization
% Human(ID, role, pos, name)
blueWhale = Human(1, 'Minnow', [0,0], 'Blue Whale');
tiger = Human(2, 'Minnow', [1.5,0], 'Tiger');
howlerMonkey = Human(3, 'Minnow', [3,0], 'Howler Monkey');

humanList = [blueWhale, tiger, howlerMonkey];

%% Robot initialization
% Robot(ID, role, pos, speed, range, xLimits, yLimits, name)
cat = Robot(1, 'Minnow', [0,0], 1, 1.5, gameBoundariesX, gameBoundariesY, 'Cat');

robotList = [cat];

%% GAME START
numOfRounds = 4;

% Automatically generate lists to keep track of the sharks vs the minnows
sharkList = [];
minnowList = [];
for i=1:length(robotList)
    if strcmp(robotList(i).role, 'Shark')
        append(sharkList, robotList(i));
    else
        append(minnow, robotList(i));
    end
end

for i=1:length(humanList)
    if strcmp(humanList(i).role, 'Shark')
        append(sharkList, humanList(i));
    else
        append(minnowList, humanList(i));
    end
end


% This loop encompasses the entire game, the basics are each game has a set
% number of rounds, in which the minnows run from one side to the other.
% Then during the round each person on the human and robot lists have their
% position updated from the QTM data.
for currentRound = 1:numOfRounds
    allFinished = 0;
    
    % Generate the round's end point, which changes from positive to
    % negative each round
    if mod(currentRound, 2) == 1
        goalPoint = 0.95 * gameBoundariesX(1);
    else
        goalPoint = 0.95 * gameBoundariesX(2);
    end
    
    
    while allFinished == 0;
        % Get data from QTM
        [data3DOF, data6DOF] = QMC(qtm, 'frameinfo');
        
        % Update the position of all of the humans
        for i=1:length(humanList)
            % Note that this also checks to see if they are a minnow and
            % have finished
            humanList(i).newData(data6DOF, goalPoint)
        end
        
        % Update the position of all robots
        for i=1:length(robotList)
            robotList(i).newData(data6DOF)
        end
        
        % Determine the appropriate velocities for each of the robots, save
        % them in the object classes to send over xBee
        for i=1:length(robotList)
            if strcmp(robotList(i).role, 'Minnow') == 1
                robotList(i).minnowMove(minnowList, sharkList, roundNum)
            elseif strcmp(robotList(i).role, 'Shark') == 1
                robotList(i).sharkMove(minnowList)
            else
                error('lol you misspelled something')
            end
        end
        
        % Check to see if any of the minnows were caught
        for i=1:length(sharkList)
            for j=1:length(minnowList)
                if minnowList(j).finished == 0
                    % For minnows that aren't finished check
                    distance = norm(sharkList(i).position-minnowList(j).position);
                    if distance <= sharkList(i).range
                        minnowList(j).finished = 1;
                        fprintf('%s was caught by %s', minnowList(j).name, sharkList(j).name)
                    end
                end
            end
        end
        
        % Send the data
        velocityString = [];
        for i=1:length(robotList)
            velocityString = [velocityString, i, robotList(i).velocity];
        end
        
        
    end
    
end

