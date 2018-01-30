%% This is the script to run the full game

% Important constants
qtm=QMC('QMC_conf_6.txt');
timeIncrement = .01;  % Number of seconds between measurements

gameBoundariesX = [-5000, 5000];
gameBoundariesY = [-5000, 5000];
sharkStartingLocations = [0,-2500; 0,0; 0,2500];
gameName = 'temp'; % use for filename output


%% Human Initialization
% Human(ID, role, pos)
blueWhale = Human(1, 'Minnow', [0,0]);
tiger = Human(2, 'Minnow', [1.5,0]);
howlerMonkey = Human(3, 'Minnow', [3,0]);

humanList = [blueWhale, tiger, howlerMonkey];

%% Robot initialization
% Robot(ID, role, pos, speed, range, xLimits, yLimits)
cat = Robot(1, 'Minnow', [0,0], 1, 1.5, gameBoundariesX, gameBoundariesY);

robotList = [cat];

%% GAME START
numOfRounds = 4;


% This loop encompasses the entire game, the basics are each game has a set
% number of rounds, in which the minnows run from one side to the other.
% Then during the round each person on the human and robot lists have their
% position updated from the QTM data.
for currentRound = 1:numOfRounds
    allFinished = 0;
    while allFinished == 0;
        % Get data from QTM
        [data3DOF data6DOF] = QMC(qtm, 'frameinfo');
        
        % Update the position of all of the humans
        for i=1:length(humanList)
            humanList(i).newData(data6DOF)
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
                error('Corey you messed up and past Corey dunno why')
            end
        end
            
            
    end
    
end

