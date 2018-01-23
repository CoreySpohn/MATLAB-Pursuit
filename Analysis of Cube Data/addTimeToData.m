format compact

% Get all of the data in an array called rawData
rawData = csvread('fullData.csv');

% The time increment for the trials (Not totally accurate due to computational time)
ti = 0.05;

% An iterator for the loop. Necessary because the time only increases every
% 6 rows
n = 1;

% Preallocate the newData array
newData = zeros(size(rawData,1),size(rawData,2)+1);

for i=1:size(rawData, 1)
    newData(i,1) = rawData(i,1);
    newData(i,2) = rawData(i,2);
    newData(i,3) = rawData(i,3);
    newData(i,4) = rawData(i,4);
    newData(i,5) = n*ti;
    
    if mod(i, 6) == 0
        n = n + 1;
    end
end
csvwrite('timeData.csv',newData)
