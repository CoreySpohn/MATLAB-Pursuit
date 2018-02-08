%% This script will take the position data from the lists provided and 
% output the data as a regular list for easier data analysis

trial = 8;
replicate = 1;
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

