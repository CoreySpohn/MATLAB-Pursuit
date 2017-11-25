%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   QMC DEMO
%
%   Initializes QMC, and creates objecthandle 'qtm'.
%
%   Getting frame info, 3D, analog and 6DOF data from QMC(qtm, 1), one
%   sample at a time. Setup in QMC_conf.txt in order to send the wanted data. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function QMCdemo(n)        % n is the amount of frames the demo should retrieve before disconnecting.

qtm = QMC('QMC_conf.txt'); % Creates the objecthandle 'qtm' which keeps the connection alive.

the3dlabels = QMC(qtm, '3dlabels');
the6doflabels = QMC(qtm, '6doflabels');

for i = 1:n
    [frameinfo the3D analog the6DOF] = QMC(qtm, 'frameinfo') % Gather data from QTM. This configuration gets the frame info and
                                                             % three different types of data from QTM. Note that the number of
                                                             % data types must be the same as in the config-file.
end

QMC(qtm, 'disconnect'); % Terminates the QMC-object.

clear mex