%% SCRIPT_UR3e_Write
close all
clc


%% Create points
SCRIPT_Test_pShapesToSplines;

%% Define writing box
% xx = [-370,-181];
% yy = [ 190, 352];
% zz = ur.Pose(3,4);
[xx,yy,zz] = defineWritingBox(ur);

x_c = xx(1) + diff(xx)/2;
y_c = yy(1) + diff(yy)/2;
z_c = zz(1) + diff(zz)/2; 

%% Transform path to new center point
H_p2c = Tx(x_c)*Ty(y_c)*Tz(z_c);

X(4,:) = 1;
X_c = H_p2c * X;

%% Plot position and velocity
%{
t = 0:dt:(size(X_c,2)-1)*dt;
fig = figure;
axs = axes('Parent',fig);
hold(axs,'on')
plot(axs,t,X_c(1,:),'r');
plot(axs,t,X_c(2,:),'g');
plot(axs,t,X_c(3,:),'b');
%}
%% Create simulation 
%{
sim = URsim;
sim.Initialize('UR3');

%% Write
sim.Joints = [-.9501; -0.6829; 1.1114; -2.0012; -1.5702; 0.7893];
for i = 1:size(X_c,2)
    H = Rx(pi);
    H(1:3,4) = X_c(1:3,i);
    
    
    sim.Pose = H;
    q(:,i) = sim.Joints;
end
%}