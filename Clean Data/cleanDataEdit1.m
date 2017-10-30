% file = 'surveyStillRobot2';
% load([file '.mat'])
% data_3d=surveySillRobot20016.Trajectories.Unidentified.Data; %note, will have to change every run
% [a b c] = size(data_3d);

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





for i=4
    
    clearvars -except fileName i average
    
%Walls   
leftWall = -4115;
rightWall = 4267;
topWall = 3785;
bottomWall = -3683;

N = 8;  %this will result in N^2 boxes
count = zeros(N);
Lx = (rightWall - leftWall) / N;
Ly = (topWall - bottomWall) / N;
% %Areas%%%%%%%%%%%%%%%%%%%%%%%%%
areaRoomNo = 58.7728;
areaRoomRobot = 58.6086;
    
areaa = areaRoomNo / N; 

file = fileName{i};
load(file);
[people b frameNum] = size(cleanData);

peopleData = cell(frameNum,1);

tic
countPeople = zeros(frameNum,N,N);

for frame=1:frameNum
    
    temp = [squeeze(-cleanData(:,3,frame))...
                         squeeze(cleanData(:,1,frame))];
                     
    peopleData{frame} = temp( ~isnan( temp(:,1) ), :);   
    
    for xbox = 1:N
        for ybox = 1:N
            
            leftside = leftWall + Lx*(xbox-1);
            rightside = leftWall + Lx*xbox;
            bottomside = bottomWall + Ly*(ybox-1);
            topside = bottomWall + Ly*xbox;
            
            countPeople(frame,xbox,ybox) = sum(leftside < peopleData{frame}(:,1) & peopleData{frame}(:,1) < rightside & bottomside < peopleData{frame}(:,2) & peopleData{frame}(:,2) < topside ) ;
        end
    end
    
end


% time = (1:frameNum)./60;
% countPeople = smooth(countPeople(1,:),0.01,'lowess');


figure(i)
avgd = squeeze(mean(countPeople,1));
imagesc(avgd)
title(file)

end
% 
% time = (1:frameNum)./60;
% countPeople = smooth(countPeople(1,:),0.01,'lowess');
% 
% if i <= 5
%     figure(1);
%     plot(time,countPeople)
%     
%     xlabel('Time (s)')
%     ylabel('Density in Room (people/m^2)') 
%     title('Color Card Density in Room Over Time')
%     
%     hold on
% elseif i > 5 && i <= 11
%     figure(2);
%     
%     plot(time,countPeople)
% 
%     xlabel('Time (s)')
%     ylabel('Density in Room (people/m^2)') 
%     title('Criss Cross Density in Room Over Time')
%     
%     hold on
% elseif i>11
%     figure(3);
%     
%     plot(time,countPeople)
% 
%     xlabel('Time (s)')
%     ylabel('Density in Room (people/m^2)') 
%     title('Multiple Choice Density in Room Over Time')
%     
%     hold on
% end
% 
%  average(i)=mean(countPeople);
%  err(i)=std(countPeople);
% 
% toc
% end
% 
% 
% 
% figure(1)
% legend('Moving 1','Moving 2', 'No Robot 1', 'No Robot 2', 'Stationary Robot 1')
% 
% figure(2)
% legend('Moving 1','Moving 2', 'No Robot 1', 'No Robot 2', 'Stationary Robot 1','Stationary Robot 2')
% 
% figure(3)
% legend('Moving 1','Moving 2','Moving 3', 'No Robot 1', 'No Robot 2','No Robot 3', 'Stationary Robot 1','Stationary Robot 2','Stationary Robot 3')
% 
% %bar plot
% ex1 = [mean(average(1:2)),mean(average(3:4)),average(5)];
% ex2 = [mean(average(6:7)),mean(average(8:9)),mean(average(10:11))];
% ex3 = [mean(average(12:14)),mean(average(15:17)),mean(average(18:20))];
% % %error on bar 
% % exr1 = [mean(std(1:2)),mean(std(3:4)),mean(5)];
% % exr2 = [mean(std(6:7)),mean(std(8:9)),mean(std(10:11))];
% % exr3 = [mean(std(12:14)),mean(std(15:17)),mean(std(18:20))];
% 
% figure(4)
% y = [ex1; ex2; ex3];
% % k = [exr1; exr2; exr3];
% bar(y) %(x)
% % errorbar(y, y, k) %(x, mean, std)