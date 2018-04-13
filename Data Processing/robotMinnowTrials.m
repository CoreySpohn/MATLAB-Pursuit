%% Trials
%
% 15 - 14 Replicates - 2 HS, 8 HM, 2 RM
% 16 - 6 Replicates - 2 HS, 3 HM, 2 RM
% 17 - 4 Replicates - 1 HS, 8 HM, 2 RM

clear
close all

%% Load the proper files based on the trial and replicate
for trial = 15:17
    
    if trial == 15
        replicates = 14;
    elseif trial == 16
        replicates = 6;
    elseif trial == 17
        replicates = 4;
    end
    
    for replicate = 1:replicates
        
        gameName = ['trial', int2str(trial), 'rep', int2str(replicate)]; % use for filename output
        folderName = ['Trial',' ', int2str(trial), '\'];
        
        humanListFilename = [folderName, gameName, 'humans.mat'];
        robotListFilename = [folderName, gameName, 'robots.mat'];
        load(humanListFilename)
        load(robotListFilename)
        
        
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
        
        
        %% Interpolation for NaN values
        % Go 1 by 1 down the line of the different lists
        % Doing a 1d cubic spline
        
        fixedPositions = [];
        for i=1:size(humanMinnowPositions,2)
            vals = humanMinnowPositions(:,i);
            if sum(isnan(vals)) == size(humanMinnowPositions,1)
                interpVals = NaN(1, size(humanMinnowPositions,1));
            else
                interpVals = interp1(vals,1:size(humanMinnowPositions,1),'cubic');
            end
            fixedPositions = [fixedPositions; interpVals];
            
        end
        humanMinnowPositions = transpose(fixedPositions);
        
        fixedPositions = [];
        for i=1:size(humanSharkPositions,2)
            vals = humanSharkPositions(:,i);
            
            interpVals = interp1(vals,1:size(humanSharkPositions,1),'cubic');
            fixedPositions = [fixedPositions; interpVals];
            
        end
        humanSharkPositions = transpose(fixedPositions);
        
        fixedPositions = [];
        for i=1:size(robotMinnowPositions,2)
            vals = robotMinnowPositions(:,i);
            
            interpVals = interp1(vals,1:size(robotMinnowPositions,1),'cubic');
            fixedPositions = [fixedPositions; interpVals];
            
        end
        robotMinnowPositions = transpose(fixedPositions);
        
        % Now that everything has been interpolated we can look at the
        % statistics of how far the humans stay from humans
        for i=1:size(humanMinnowPositions,2)/2
            % i = current column/minnow
            
            for j=1:size(humanMinnowPositions,1)
                % j = current row/step
                distances = [];
                % Calculate the minimum distance from human i to a human k
                for k = 1:size(humanMinnowPositions,2)/2
                    % k = other minnows
                    if i == k
                        % don't let it check vs itself
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    % if either minnow is out of bounds this distance
                    % is a NaN
                    if humanMinnowPositions(j,2*i-1)> 3000 || humanMinnowPositions(j,2*i-1)< -4000
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    if humanMinnowPositions(j,2*k-1)> 3000 || humanMinnowPositions(j,2*k-1)< -4000
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    if humanMinnowPositions(j,2*i)> 3000 || humanMinnowPositions(j,2*i)< -4000
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    if humanMinnowPositions(j,2*k)> 3000 || humanMinnowPositions(j,2*k) < -4000
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    xPos = humanMinnowPositions(j,2*i-1)- humanMinnowPositions(j,2*k-1);
                    yPos = humanMinnowPositions(j,2*i)- humanMinnowPositions(j,2*k);
                    dist = sqrt(xPos^2+yPos^2);
                    
                    distances = [distances; dist];
                end
                
                if sum(isnan(distances)) == length(distances)
                    % if every value is a NaN then make this entry a
                    % NaN
                    minDistance = NaN;
                else
                    minDistance = min(distances);
                end
                minDistances(j,i) = minDistance;
            end
            averageMinHumanDistances = nanmean(minDistances)/1000;
            
            totalMinHumanDistance(replicate, trial-12) = nanmean(averageMinHumanDistances);
            totalMinHumanDistance(totalMinHumanDistance == 0 ) = NaN;
            totalMinHumanStd(replicate, trial-12) = sqrt(sum(var(averageMinHumanDistances, 'omitnan')));
            totalMinHumanStd(totalMinHumanStd == 0 ) = NaN;

        end
        
        %Now do the same for the humans vs the robots
        for i=1:size(humanMinnowPositions,2)/2
            % i = current column/minnow
            
            for j=1:size(humanMinnowPositions,1)
                % j = current row/step
                distances = [];
                % Calculate the minimum distance from human i to a human k
                for k = 1:size(robotMinnowPositions,2)/2
                    % k = robots
                    if i == k
                        % don't let it check vs itself
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    % if either minnow is out of bounds don't count this
                    % minnow for this step
                    if humanMinnowPositions(j,2*i-1)> 3000 || humanMinnowPositions(j,2*i-1)< -4000
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    if robotMinnowPositions(j,2*k-1)> 3000 || robotMinnowPositions(j,2*k-1)< -4000
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    if humanMinnowPositions(j,2*i)> 3000 || humanMinnowPositions(j,2*i)< -4000
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    if robotMinnowPositions(j,2*k)> 3000 || robotMinnowPositions(j,2*k) < -4000
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    xPos = humanMinnowPositions(j,2*i-1)- robotMinnowPositions(j,2*k-1);
                    yPos = humanMinnowPositions(j,2*i)- robotMinnowPositions(j,2*k);
                    dist = sqrt(xPos^2+yPos^2);
                    
                    distances = [distances; dist];
                end
                
                if sum(isnan(distances)) == length(distances)
                    % if every value is a NaN then make this entry a
                    % NaN
                    minDistance = NaN;
                else
                    minDistance = min(distances);
                end
                minDistances(j,i) = minDistance;
            end
            averageMinRobotDistances = nanmean(minDistances)/1000;
            
            totalMinRobotDistance(replicate, trial-12) = nanmean(averageMinRobotDistances);
            totalMinRobotDistance(totalMinRobotDistance == 0 ) = NaN;
            finalMinRobotDistances = nanmean(totalMinRobotDistance);
            
            totalMinRobotStd(replicate, trial-12) = sqrt(sum(var(averageMinRobotDistances, 'omitnan')));
            totalMinRobotStd(totalMinRobotStd == 0 ) = NaN;
            finalMinRobotStd = sqrt(nanmean(totalMinRobotStd.^2));
        end
        
        % now calculate how much further the humans stayed from the
        % robots for each trial when compared to the humans
%         for i = 1:size(totalMinHumanDistance,2)-2
%             for j = 1:size(totalMinHumanDistance,1)
%                 dividedComparison(j, i) = totalMinRobotDistance(j, i) / totalMinHumanDistance(j, i+2);
%             end
%         end
    end
    
end


%% Trials 3 and 4
for trial = 3:4
    
    if trial == 3
        replicates = 21;
    elseif trial == 4
        replicates = 15;
    end
    
    for replicate = 1:replicates
        gameName = ['trial', int2str(trial), 'rep', int2str(replicate)]; % use for filename output
        folderName = ['Trial',' ', int2str(trial), '\'];
        filename = [folderName, gameName, '.mat'];
        load(filename)
        robotList = [];

        
        
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

        %% Now that everything is split up get just their position data
        humanMinnowPositions = [];
        humanSharkPositions = [];
        
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
        
        %% Interpolation for NaN values
        % Go 1 by 1 down the line of the different lists
        % Doing a 1d cubic spline
        
        fixedPositions = [];
        for i=1:size(humanMinnowPositions,2)
            vals = humanMinnowPositions(:,i);
            if sum(isnan(vals)) == size(humanMinnowPositions,1)
                interpVals = NaN(1, size(humanMinnowPositions,1));
            else
                interpVals = interp1(vals,1:size(humanMinnowPositions,1),'cubic');
            end
            fixedPositions = [fixedPositions; interpVals];
            
        end
        humanMinnowPositions = transpose(fixedPositions);
        
        fixedPositions = [];
        for i=1:size(humanSharkPositions,2)
            vals = humanSharkPositions(:,i);
            
            interpVals = interp1(vals,1:size(humanSharkPositions,1),'cubic');
            fixedPositions = [fixedPositions; interpVals];
            
        end
        humanSharkPositions = transpose(fixedPositions);
        
        % Now that everything has been interpolated we can look at the
        % statistics of how far the humans stay from humans
        for i=1:size(humanMinnowPositions,2)/2
            % i = current column/minnow
            
            for j=1:size(humanMinnowPositions,1)
                % j = current row/step
                distances = [];
                % Calculate the minimum distance from human i to a human k
                for k = 1:size(humanMinnowPositions,2)/2
                    % k = other minnows
                    if i == k
                        % don't let it check vs itself
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    % if either minnow is out of bounds this distance
                    % is a NaN
                    if humanMinnowPositions(j,2*i-1)> 3000 || humanMinnowPositions(j,2*i-1)< -4000
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    if humanMinnowPositions(j,2*k-1)> 3000 || humanMinnowPositions(j,2*k-1)< -4000
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    if humanMinnowPositions(j,2*i)> 3000 || humanMinnowPositions(j,2*i)< -4000
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    if humanMinnowPositions(j,2*k)> 3000 || humanMinnowPositions(j,2*k) < -4000
                        dist = NaN;
                        distances = [distances; dist];
                        continue
                    end
                    
                    xPos = humanMinnowPositions(j,2*i-1)- humanMinnowPositions(j,2*k-1);
                    yPos = humanMinnowPositions(j,2*i)- humanMinnowPositions(j,2*k);
                    dist = sqrt(xPos^2+yPos^2);
                    
                    distances = [distances; dist];
                end
                
                if sum(isnan(distances)) == length(distances)
                    % if every value is a NaN then make this entry a
                    % NaN
                    minDistance = NaN;
                else
                    minDistance = min(distances);
                end
                minDistances(j,i) = minDistance;
                minStd(j, i) = sqrt(mean(var(minDistances/1000, 'omitnan')));
            end
            
            averageMinHumanDistances = nanmean(minDistances)/1000;
            
            totalMinHumanDistance(replicate, trial-2) = nanmean(averageMinHumanDistances);
            totalMinHumanDistance(totalMinHumanDistance == 0 ) = NaN;
            finalMinHumanDistances = nanmean(totalMinHumanDistance);
            
            totalMinHumanStd(replicate, trial-2) = sqrt(sum(var(averageMinHumanDistances, 'omitnan')));
            totalMinHumanStd(totalMinHumanStd == 0 ) = NaN;
            finalMinHumanStd = sqrt(nanmean(totalMinHumanStd.^2));
        end
        
    end
    
end

finalMinDistances = [transpose(finalMinHumanDistances), transpose(finalMinRobotDistances)];
finalMinStds = [transpose(finalMinHumanStd), transpose(finalMinRobotStd)];

%this plots the velocity bar plot with error bars, the error bars are added in the two
%for loops 
figure()
y=barwitherr(finalMinStds, finalMinDistances);
% for k1 = 1:size(y,2)
%     ctr(k1,:) = bsxfun(@plus, y(k1).XData, [y(k1).XOffset]');             % Centres Of Bar Groups
%     ydt(k1,:) = y(k1).YData;                                                 % Y-Data Of Bar Groups
% end
% hold on
% for k1 = 1:size(y,2)
%     errorbar(ctr(k1,:), ydt(k1,:), finalMinStds(k1,:), '.r')
% end
% hold off

set(gca,'XTickLabel', {'A','B','E','F','G'})


title('Nearest Neighbor Distances For Human Minnows')
xlabel('Trial')
ylabel('Distance (m)')
colormap(summer(3));
grid on
l = cell(1,2);
l{1}='Human Minnow'; l{2}='Robot Minnow';
legend(y,l,'Location','northwest');