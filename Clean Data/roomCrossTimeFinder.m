%This program determines how long it took each person to cross the room
%currently assumes only one crossing per person so it is only good for the
%multiple choice experiments
clear all; close all;
%User constants
file = 'surveyMovingRobot2(clean).mat';
leftWall = -4115;
rightWall = 4267;
topWall = 3785;
bottomWall = -3683;
%load data
load(file);%format: person,(x,y,z or 'force'),frame
%count number of people
[nPeople,tmp1,nFrames] = size(cleanData);
crossTime = zeros(2,nPeople);

%calculate time person was in room
for ii=1:nPeople
    %read data and add time dimension
    auxp = [squeeze(cleanData(ii,[1:3],:)); 0:1/60:nFrames/60-1/60];
    P{ii} = auxp;
    
    a=find((P{ii}(1,:) > leftWall) & (P{ii}(1,:) < rightWall) & (P{ii}(3,:) > bottomWall) 
    & (P{ii}(3,:) < topWall));
    last = length(a);
    crossTime(1,ii) = P{ii}(4,a(1));
    crossTime(2,ii) = P{ii}(4,a(last));
end

save([file(1:end-11) '(crossTime).mat'],'crossTime');

% look at the data for one guy
ind = 2;

figure, hold on
plot(P{ind}(4,:),P{ind}([1,3],:))
xlabel('time (s)')
legend('x','y')

line([crossTime(1,ind),crossTime(1,ind)], [-3000 3000]);
line([crossTime(2,ind),crossTime(2,ind)], [-3000 3000]);