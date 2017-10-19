% Color Card Exp
fileName{1}='colorMovingRobot1(clean).mat';
fileName{2}='colorNoRobot2(clean).mat';
fileName{3}='colorStillRobot1(clean).mat';

%Criss Cross Exp
fileName{4}='crissMovingRobot1(clean).mat';
fileName{5}='crissNoRobot1(clean).mat';
fileName{6}='crissStillRobot1(clean).mat';

% Survey Exp
fileName{7}='surveyMovingRobot1(clean).mat';
fileName{8}='surveyNoRobot1(clean).mat';
fileName{9}='surveyStillRobot1(clean).mat';

for i=1:9
    
    clearvars -except fileName i average
    
%wall coordinates
leftWall = -4115;
rightWall = 4267;
topWall = 3785;
bottomWall = -3683;
%Areas
areaRoomNo = 58.7728;
areaRoomRobot = 58.6086;
    
file = fileName{i};
load(file);
[people b frameNum] = size(cleanData);

peopleData = cell(frameNum,1);

tic
for frame=1:frameNum
    
    temp = [squeeze(-cleanData(:,3,frame))...
                         squeeze(cleanData(:,1,frame))];
                     
    peopleData{frame} = temp( ~isnan( temp(:,1) ), :);   
    
    
    countPeople(frame) = sum(leftWall < peopleData{frame}(:,1) & peopleData{frame}(:,1) < rightWall & 
    bottomWall < peopleData{frame}(:,2) & peopleData{frame}(:,2) < topWall ) / areaRoomNo;

end

time = (1:frameNum)./60;
countPeople = smooth(countPeople(1,:),0.01,'lowess');

if i <= 5
    figure(1);
    plot(time,countPeople)
    
    xlabel('Time (s)')
    ylabel('Density in Room (people/m^2)') 
    title('Color Card Density in Room Over Time')
    
    hold on
elseif i > 5 && i <= 11
    figure(2);
    
    plot(time,countPeople)

    xlabel('Time (s)')
    ylabel('Density in Room (people/m^2)') 
    title('Criss Cross Density in Room Over Time')
    
    hold on
elseif i>11
    figure(3);
    
    plot(time,countPeople)

    xlabel('Time (s)')
    ylabel('Density in Room (people/m^2)') 
    title('Multiple Choice Density in Room Over Time')
    
    hold on
end

 average(i)=mean(countPeople);
 err(i)=std(countPeople);

toc
end



figure(1)
legend('Moving Robot', 'No Robot', 'Stationary Robot')

figure(2)
legend('Moving Robot', 'No Robot', 'Stationary Robot')

figure(3)
legend('Moving Robot', 'No Robot', 'Stationary Robot')


ex1 = [average(1),average(2),average(3)];
ex2 = [average(4),average(5),average(6)];
ex3 = [average(7),average(8),average(9)];

c = [ex2; ex3; ex1];

%Bar plot
figure(4)
bar(c)
Labels = {'Criss Cross','Multiple Choice','Color Card'};
set(gca, 'XTick',1:3,'XTickLabel',Labels)
xlabel('Experiment')
ylabel('Density in Room (people/m^2)')
title('Density for Each Experiment')