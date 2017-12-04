%% Setup QTM
q=QMC('QTMconfig16.txt');   %Must create a config file

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

[data_3d, data_6dof] = QMC(q);

%% Whether the names are in a column, whether they show up in the same place if they disappear,
% How easy it is to separarte the values. 