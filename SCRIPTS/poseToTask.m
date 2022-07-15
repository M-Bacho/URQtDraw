function X = poseToTask(H_b2e)

d_b2e = H_b2e(1:3,4);
phi = atan2(H_b2e(1,1),H_b2e(2,1));

X = [d_b2e; phi];

end

