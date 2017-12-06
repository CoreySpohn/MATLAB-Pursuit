%% Setup QTM
q=QMC('QMC_conf_6.txt');   %Must create a config file

% %% Setup Serial Communication
% try
%     fclose(xBee);
%     delete(xBee);
%     clear xBee;
%     fprintf('Old MATLAB serial port needed to be closed first\n');
% catch
% end
% 
% try
%     xBee = serial('COM5', 'BaudRate', 9600, 'Parity', 'none', 'DataBits', 8);
%     fopen(xBee);
%     fprintf('Matlab serial port was created\n');
% catch
%     fprintf('Matlab serial port failed to be created.\n');
%     return
% end
the3dlabels = QMC(qtm, '3dlabels');
the6doflabels = QMC(qtm, '6doflabels');
for i = 1:100
    [frameinfo data] = QMC(qtm, 'frameinfo') % Gather data from QTM. This configuration gets the frame info and
                                                             % three different types of data from QTM. Note that the number of
                                                             % data types must be the same as in the config-file.
                                                             
end

QMC(qtm, 'disconnect'); % Terminates the QMC-object.

clear mex
%% Whether the names are in a column, whether they show up in the same place if they disappear,
% How easy it is to separarte the values. 