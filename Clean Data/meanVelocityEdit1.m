clear
load('surveyStillRobot1(clean).mat')

[people junk frames] = size(cleanData);

for t=1:frames-1
    
    location1 = squeeze(cleanData(:,[1 3],t))./1000;
    location2 = squeeze(cleanData(:,[1 3],t+1))./1000;
    vel = 60.*(location1-location2);
    speed = sqrt(vel(:,1).^2+vel(:,2).^2);
    meanV(t) = nanmean(speed);
end

%smoothing out plot
meanV = smooth(meanV(1,:),0.05,'lowess');
%

%plot((1:frames-1)./60,meanV,'b')
%xlabel('Time, s')
%ylabel('Average Speed, m/s')
%hold on
%overallAverage = nanmean(meanV);