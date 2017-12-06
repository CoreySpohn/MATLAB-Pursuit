%% Setup QTM
q=QMC('QTMconfig16.txt');   %Must create a config file
minDistToRobot = 1000;  %Free Space needed to move (radius in m)
maxDist = 0.3;

leftWall = -4;
rightWall = 4267;
topWall = 3785;
bottomWall = -3683;
numberOfRobots = 1; % This is necessary if we can't use the ID names

%% Setup Serial Communication
try
    fclose(xBee);
    delete(xBee);
    clear xBee;
    fprintf('Old MATLAB serial port needed to be closed first\n');
catch
end

try
    xBee = serial('COM3', 'BaudRate', 9600, 'Parity', 'none', 'DataBits', 8);
    fopen(xBee);
    fprintf('Matlab serial port was created\n');
catch
    fprintf('Matlab serial port failed to be created.\n');
    return
end

% %% Get Initial Values, Set Up Plot
% % People Data
% % Takes all data from the 6 degree of freedom matrix
% [data_3d, data_6dof] = QMC(q);
% [a, people, c] = size (data_6d);
% numberOfMinnows = length(data_6d) - numberOfRobots;
% minnowData = [-data_6d(1,1:numberOfMinnows) ; data_6d(3,1:numberOfMinnows) ; data_6d(4,1:numberOfMinnows)];  % Create a matrix of [x, y, t] data for the minnows
% minnowData(minnowData==0)=NaN; % Maybe take out
% 
% % Remove people outside bounds
% minnowData(:,minnowData(1,1:numberOfMinnows)<leftWall)=NaN;
% minnowData(:,minnowData(1,1:numberOfMinnows)>rightWall)=NaN;
% minnowData(:,minnowData(2,1:numberOfMinnows)<bottomWall)=NaN;
% minnowData(:,minnowData(2,1:numberOfMinnows)>topWall)=NaN;
% 
% % This makes an array with the values in the order:
% % x, y, t, vx, vy
% fullMinnowData = zeroes(1:6);
% n = 0;
% m = 0;
% 
% %% WORKING ON THIS
% for n = 1:length(minnowData)
%     dT = minnowData(n,3) - previousPeopleData(n,3); % THE SECOND PART DOESN'T EXIST YET
%     fullMinnowData(n,1) = minnowData(n,1); % x position
%     fullMinnowData(n,2) = minnowData(n,2); % y position
%     fullMinnowData(n,3) = minnowData(n,3); % t time
%     fullMinnowData(n,4) = Velocity_calc(minnowData(n,1),previousPeopleData(n,1),dT); % x velocity
%     fullMinnowData(n,5) = Velocity_calc(minnowData(n,2),previousPeopleData(n,2),dT); % y velocity
%     fullMinnowData(n,6) = 0; % This will indicate if the minnow has been caught (1) or not (0)
% end
% % Robot Data
% currentLoc = [-data_6dof(3) data_6dof(1)];            %Ground Position
% orientation = data_6dof(4);           %Idealy, only 1 angle needed
% 
% % Calculate Disred Position: Mean
% meanVec = nanmean( minnowData , 2)';        %2-D Mean Location
% 
% % % Plot
% % figure(1)
% % clf
% % title('Current Positions')
% % scatter(peopleData(1,:),peopleData(2,:))
% % hold on
% % scatter(meanVec(1),meanVec(2), 'rx')
% % scatter(currentLoc(1),currentLoc(2), 'go')
% % plot([leftWall rightWall],[bottomWall bottomWall],'k')
% % plot([leftWall rightWall],[topWall topWall],'k')
% % plot([leftWall leftWall],[bottomWall topWall],'k')
% % plot([rightWall rightWall],[bottomWall topWall],'k')
% % xlim([-5000 5000])
% % ylim([-5000 5000])
% 
% % Make string for xBee and send it
% str = [num2str(distanceToMove(1),4) ' ' num2str(distanceToMove(2),4) ' ' num2str(angleAdjust,4) 'a'];
% fprintf([str '\n']);
% try
%     fprintf(xBee,'%s',str);
% catch ME
%     fprintf('ERROR\n');
%     fprintf(ME);
% end
% 
% %% Loop that ends when all minnows are tagged or on the other side
% while True
%     
% end