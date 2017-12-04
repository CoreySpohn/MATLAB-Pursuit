qtm=QMC('QMC_conf.txt');

tstep=2;
numSec=20;

format shortg;
for i=1:numSec*3
    [frameinfo data] = QMC(qtm, 'frameinfo')
    %data_6dof
%     data_6dof =QMC(q)

  %  data_3d;
  %  data=data_6dof;
  %  traj(i,:)=data(1:3);
   % ang(i,:)=data(4:6);
end
QMC(qtm,'disconnect')

   % plot3(traj(:,1),traj(:,3),traj(:,2))
    %hold on
    %faxis equal
