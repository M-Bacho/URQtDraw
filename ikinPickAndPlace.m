function [q_eu, q_ed] = ikinPickAndPlace(X,L)
    a1 = -X(2);
    b1 = -X(1);
    c1 = sqrt((a1^2) + (b1^2));
    alpha1 = atan2(a1,b1);
    
    a2 = L(4);
    b2 = sqrt((c1^2) - (a2^2));
    alpha2 = atan2(a2,b2);
    
    theta1 = alpha1 - alpha2;
    c3 = b2 - L(5);
    
    a4 = (X(3)+L(6)) - L(1);
    c4 = sqrt((c3)^2 + (a4)^2);
    alpha4 = atan2(a4,c3);
    b5 = L(2);
    a5 = L(3);
    
    alpha5 = acos(((b5)^2 + (c4)^2 - (a5)^2)/(2*b5*c4));
    gamma5 = acos(((a5)^2 + (b5)^2 - (c4)^2)/(2*a5*b5));
    
    theta5 = -pi/2;
    theta6 = ((pi/2) + theta1 - X(4));
    %% Elbow up solution
    eu_theta2 = -(alpha4 + alpha5);
    eu_theta3 = pi - gamma5;
    
    eu_theta4 = -(eu_theta2 + eu_theta3 + (pi/2));
    %% Elbow down solution
    ed_theta2 = -(alpha4 - alpha5);
    ed_theta3 = gamma5 - pi;
    
    ed_theta4 = -(ed_theta2 + ed_theta3 + (pi/2));

    %%
    q_eu = [theta1; eu_theta2; eu_theta3; eu_theta4; theta5; theta6];
    q_ed = [theta1; ed_theta2; ed_theta3; ed_theta4; theta5; theta6];
end
    