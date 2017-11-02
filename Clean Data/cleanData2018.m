clc

% Create a cell array storing the names of the data files. A cell array is way to store strings in matlab. To add more file
% names use the format: fileName{2}='colorNoRobot2(clean).mat';
fileName{1}='colorMovingRobot1(clean).mat';
fileName{2}='colorNoRobot2(clean).mat';

%stores the x and y position data for each data file
[c fileSize] = size(fileName);
allFileData = cell(fileSize,1);

%loop through each file
for i=1:fileSize
    
%load the file and store the dimensions as separate variables
file = fileName{i};
load(file);
[people xzytData frameNum] = size(cleanData);

%initialize a variable that stores the x and y people data for each frame
peopleData = cell(frameNum,1);

for frame=1:frameNum
    %combining the x and y data into a matrix, this is the format from last
    %year, not sure why there is a negative before frame 3 or what order
    %qualysis stores x and y data
    temp = [squeeze(-cleanData(:,3,frame))...
                         squeeze(cleanData(:,1,frame))];
    %filtering out nan values                 
    peopleData{frame} = temp( ~isnan( temp(:,1) ), :);   
    
end

allFileData{i} = peopleData;

end
