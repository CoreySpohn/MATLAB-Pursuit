qtm=QMC('QMC_conf_6.txt');

timeIncrement = .01;  % Number of seconds between measurements
seconds = 180;  % Length of trial in seconds
numOfMinnows = 2;  % Number of minnows
numOfSharks = 1;  % Number of sharks

format compact;
fullData = [];
for i=1:seconds/timeIncrement
    [data3DOF data6DOF] = QMC(qtm, 'frameinfo');
    data6DOF  % Print the 6 degree of freedom data
    fullData = [fullData;data6DOF]; % Make a giant array with all of the data
    pause(timeIncrement)  % Wait the indicated period of time until the next measurement
    
end
QMC(qtm,'disconnect')

%% This is going to be to sort the data into arrays for each agent
% Want to have a list of minnows and each minnow can be accessed through
% the list. This allows us to look through them with one loop.

% minnowList = zeroes(1:numOfMinnows);  % Initialize the list of Minnows with 0s
% sharkList = zeroes(1:numOfSharks);  % Initialize the list of Sharks with 0s
% 
% for i=1:size(data6DOF(2))
%     minnowList(i) = [minnowList(i);data6DOF(:,1)];
% end