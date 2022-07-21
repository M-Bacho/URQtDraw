%% URQt Create Joints (Inverse Kinematics)

X = X_c;    %X_c created in SCRIPT_UR3e_WriteCopy
X(4,:) = 0;
L = [151.85; 243.55; 213.20; 131.05; 85.35; 92.10];

q_up = [];
q_dn = [];

for i = 1:length(X)
    [q_eu, q_ed] = ikinPickAndPlace(X(:,i),L);
    q_up(:,i) = q_eu;
    q_dn(:,i) = q_ed;
end

writematrix(q_up,'Joints_up.csv','Delimiter',',');
writematrix(q_dn,'Joints_dn.csv','Delimiter',',');
