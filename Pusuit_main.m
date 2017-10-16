%% Setup QTM
q=QMC('QTMconfig16.txt');   %Must create a config file
minDistToRobot = 1000;  %Free Space needed to move (radius in m)
maxDist = 0.3;

leftWall = -4115;
rightWall = 4267;
topWall = 3785;
bottomWall = -3683;

%% Setup Serial Communication
try
    fclose(xBee);
    delete(xBee);
    clear xBee;
    fprintf('Old MATLAB serial port needed to be closed first\n');
catch
end

try
    xBee = serial('COM5', 'BaudRate', 9600, 'Parity', 'none', 'DataBits', 8);
    fopen(xBee);
    fprintf('Matlab serial port was created\n');
catch
    fprintf('Matlab serial port failed to be created.\n');
    return
end