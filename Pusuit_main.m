%% Setup QTM
q=QMC('QTMconfig16.txt');   %Must create a config file
minDistToRobot = 1000;  %Free Space needed to move (radius in m)
maxDist = 0.3;

leftWall = -4;
rightWall = 4267;
topWall = 3785;
bottomWall = -3683;

%% Setup Serial Communication
try
    fclose(xBee);
    delete(xBee);
    clear xBee;
    fprintf('Old MATLAB serial port needed to be closed first\n');
catch
end

try
    xBee = serial('COM5', 'BaudRate', 9600, 'Parity', 'none', 'DataBits', 8);
    fopen(xBee);
    fprintf('Matlab serial port was created\n');
catch
    fprintf('Matlab serial port failed to be created.\n');
    return
end

%% Get Initial Values, Set Up Plot
    %People Data
    %creates two different data types, 3d for N people size: (N,3)
    %6d for robot only, size:(1,6)
    [data_3d, data_6dof] = QMC(q);
    [a, people, c] = size (data_3d);
    peopleData = [-data_3d(1,:) ; data_3d(3,:) ; data_3d(4,:)];  %Create a 
    peopleData(peopleData==0)=NaN; %maybe take out
    
    %remove people outside walls
    peopleData(:,peopleData(1,:)<leftWall)=NaN;
    peopleData(:,peopleData(1,:)>rightWall)=NaN;
    peopleData(:,peopleData(2,:)<bottomWall)=NaN;
    peopleData(:,peopleData(2,:)>topWall)=NaN;
    
    % This makes an array with the values in the order:
        % x, y, t, vx, vy
    siftedPeopleData = zeroes(1:6);
    n = 0;
    m = 0;
    
    %% WORKING ON THIS
    for n = 1:length(peopleData)
        dT = peopleData(n,3) - previousPeopleData(n,3) % THE SECOND PART DOESN'T EXIST YET
        siftedPeopleData(n,1) = peopleData(n,1); % x position
        siftedPeopleData(n,2) = peopleData(n,2); % y position
        siftedPeopleData(n,3) = peopleData(n,3); % t time
        siftedPeopleData(n,4) = Velocity_calc(peopleData(n,1),previousPeopleData(n,1),dT); % x velocity
        siftedPeopleData(n,5) = Velocity_calc(peopleData(n,2),previousPeopleData(n,2),dT);
        n = n + 1
    end
    % Robot Data
    currentLoc = [-data_6dof(3) data_6dof(1)];            %Ground Position
    orientation = data_6dof(4);           %Idealy, only 1 angle needed
    
    % Calculate Disred Position: Mean
    meanVec = nanmean( peopleData , 2)';        %2-D Mean Location
    
    % Plot
    figure(1)
    clf
    title('Current Positions')
    scatter(peopleData(1,:),peopleData(2,:))
    hold on
    scatter(meanVec(1),meanVec(2), 'rx')
    scatter(currentLoc(1),currentLoc(2), 'go')
    plot([leftWall rightWall],[bottomWall bottomWall],'k')
    plot([leftWall rightWall],[topWall topWall],'k')
    plot([leftWall leftWall],[bottomWall topWall],'k')
    plot([rightWall rightWall],[bottomWall topWall],'k')
    xlim([-5000 5000])
    ylim([-5000 5000])