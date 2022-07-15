%% SCRIPT_UR3e_ExecuteDraw
% This script executes a drawing assuming X_c contains the waypoints for
% the drawing. This script can be used with SCRIPT_UR3e_Write which is
% contained in the Example Scripts of the Plotting Toolbox.
%
%   M. Bacho, 13Jul2022, USNA

%% Test X_c
% Test the arc length between waypoints
d_c = sqrt( sum(diff(X_c(1:3,:),1,2).^2,1) );
figure; plot(d_c);

%% Create display figure
%sim = URsim;
%sim.Initialize('UR3');
%axs = sim.Axes;
fig = figure;
axs = axes('Parent',fig);
hold(axs,'on');
view(axs,3);
daspect(axs,[1 1 1]);

% Desired path
plt_X_c = plot3(axs,X_c(1,:),X_c(2,:),X_c(3,:),'b');
% Current waypoint
plt_X_w= plot3(axs,nan,nan,nan,'*g');
% Current pose
plt_X_n = plot3(axs,nan,nan,nan,'r');

%% Set Constants
L = [151.85; 243.55; 213.20; 131.05; 85.35; 92.10];
phi = 0;


%% Attempt 1
%{
s = 10;

ur.FlushBuffer;
ur.WaitOn = false;
for i = 1:4:size(X_c,2)
    % Use pose command
%{
    H_e2o = Rx(pi);
    H_e2o(1:3,4) = X_c(1:3,i);
    
    ur.Pose = H_e2o;
    q(:,i) = ur.Joints;
%}
    
    % Use Jacobian & ServoJ
    % -> Current joint configuration
    q6 = ur.Joints;
    q4 = q6toq4(q6);
    % -> Current Jacobian
    J = JacobianPickAndPlace(q4,L);
    
    % -> Current pose
    H_e2o = ur.Pose;
    % -> Current task configuration
    Xi = poseToTask(H_e2o);
    % -> Desired task configuration
    Xf = [X_c(1:3,i); phi];
    
    % UPDATE PLOT ---------------------------------------------------------
    %sim.Joints = q6;
    
    % Current State
    xx = get(plt_X_n,'XData');
    yy = get(plt_X_n,'YData');
    zz = get(plt_X_n,'ZData');
    xx = [xx,Xi(1)];
    yy = [yy,Xi(2)];
    zz = [zz,Xi(3)];
    set(plt_X_n,'XData',xx,'YData',yy,'ZData',zz);
    
    % Desired State
    set(plt_X_w,'XData',Xf(1),'YData',Xf(2),'ZData',Xf(3));
    % ---------------------------------------------------------------------
    
    % Calculate dX
    % Calculate change in task configuration
    dX = Xf - Xi;
    % Impose maximum step size
    if s < norm(dX(1:3))
        dX(1:3) = s * (dX(1:3)./norm(dX(1:3)));
    end
    dX(4) = 0; % <--- TEMP FIX
    
    dq = ( JacobianPickAndPlace(q4,L)^(-1) )*dX;
    
    % Calculate final joint configuration
    qf = q4 + dq;
    % Convert 4-element joint configuration to 6-element joint configuration
    Qf = q4toq6(qf);
    % Send 6-element joint configuration to the robot
    ur.ServoJ(Qf);
end
%}

%% Attempt 2
ur.FlushBuffer;
ur.WaitOn = true;

max_move    = 1.00;    % Maximum movement for a given step (mm)
change_dist =  0.50;    % Distance threshold for changing waypoints (mm)
i_delta = 1;            % Index value change
i_max = size(X_c,2);    % Maximum index

% Move to first waypoint
H_e2o = Rx(pi);
H_e2o(1:3,4) = X_c(1:3,1);
ur.Pose = H_e2o;

% Adjust gain, lookahead, and blocktime
ur.Gain          = 500;     % Makes movements more drastic (higher accelerations)
ur.BlockingTime  = 0.13;    % Should be just above the time it takes for the loop to run
ur.LookAheadTime = 0.30;    % Not sure what this does, but should be bigger than blocking time?

% Loop
i = 1;
tt = [];
while true
    %tic
    if i > i_max
        break
    end
    
    % Use Jacobian & ServoJ
    % -> Current joint configuration
    q6 = ur.Joints;
    q4 = q6toq4(q6);
    % -> Current Jacobian
    J = JacobianPickAndPlace(q4,L);
    
    % -> Current pose
    H_e2o = ur.Pose;
    % -> Current task configuration
    Xi = poseToTask(H_e2o);
    % -> Desired task configuration
    Xf = [X_c(1:3,i); phi];
    
    % UPDATE PLOT ---------------------------------------------------------
    %sim.Joints = q6;
    
    % Current State
    xx = get(plt_X_n,'XData');
    yy = get(plt_X_n,'YData');
    
    zz = get(plt_X_n,'ZData');
    xx = [xx,Xi(1)];
    yy = [yy,Xi(2)];
    zz = [zz,Xi(3)];
    set(plt_X_n,'XData',xx,'YData',yy,'ZData',zz);
    
    % Desired State
    set(plt_X_w,'XData',Xf(1),'YData',Xf(2),'ZData',Xf(3));
    % ---------------------------------------------------------------------
    
    % Calculate dX
    % Calculate change in task configuration
    dX = Xf - Xi;
    
    % Check if we need to move waypoints
    if norm(dX(1:3)) < change_dist
        i = i+i_delta;
        continue
    end
    
    % Impose maximum step size
    if max_move < norm(dX(1:3))
        dX(1:3) = max_move * (dX(1:3)./norm(dX(1:3)));
    end
    dX(4) = 0; % <--- TEMP FIX
    
    dq = ( JacobianPickAndPlace(q4,L)^(-1) )*dX;
    
    % Calculate final joint configuration
    qf = q4 + dq;
    % Convert 4-element joint configuration to 6-element joint configuration
    %Qf = q4toq6(qf); % <--- sometimes gives super bad scary fault
    Qf = q4toq6(qf,q6);
    
    % Send 6-element joint configuration to the robot
    ur.ServoJ(Qf);
    
    %tt(end+1) = toc;
end

