fileName='crissMovingRobot1(clean).mat';

%Walls   
leftWall = -4115;
rightWall = 4267;
topWall = 3785;
bottomWall = -3683;

N = 2;  %this will result in N^2 boxes
count = zeros(N);
Lx = (rightWall - leftWall) / N;
Ly = (topWall - bottomWall) / N;
% %Areas%%%%%%%%%%%%%%%%%%%%%%%%%
areaRoomNo = 58.7728;
areaRoomRobot = 58.6086;
    
areaa = areaRoomNo / N; 

load(fileName);
[people b frameNum] = size(cleanData);

peopleData = cell(frameNum,1);

tic
countPeople = zeros(N,N);

%  v=VideoWriter([fileName '.avi']);
%     v.Quality=100;
%     v.FrameRate=60/2;
%     open(v);

%TO ADD: colorbar, better title, labels? actual video writer
% speed video up by 2x
figAn = figure(1);
for frame=1:2:frameNum
    
    temp = [squeeze(-cleanData(:,3,frame))...
                         squeeze(cleanData(:,1,frame))];
                     
    peopleData{frame} = temp( ~isnan( temp(:,1) ), :);   
    
    for xbox = 1:N
        for ybox = 1:N
            
            leftside = leftWall + Lx*(xbox-1);
            rightside = leftWall + Lx*xbox;
            bottomside = bottomWall + Ly*(ybox-1);
            topside = bottomWall + Ly*xbox;
            
            countPeople(xbox,ybox) = sum(leftside < peopleData{frame}(:,1) & peopleData{frame}(:,1) < rightside & bottomside < peopleData{frame}(:,2) & peopleData{frame}(:,2) < topside ) ;
        end
    end
    imagesc(countPeople)
        title('Density of Room, Criss Cross, Moving Robot')
        h = colorbar;
        caxis([0 8])
        ylabel(h, 'Number of People')
        
        xlabel('X Box')
        ylabel('Y Box')
        axis equal
        
        pause(0.001)
        
%         framePic=getframe(figAn);
%         writeVideo(v,framePic);
end
% close(v);