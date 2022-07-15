function q6 = q4toq6(q4,q6_i)
% Q4TOQ6 converts a 4-element joint configuration for a "pick-and-place" UR
% application to a 6-element joint configuration.
%   q6 = q4toq6(q4)
%
%   q6 = q4toq6(q4,q6_i)
%
%   M. Bacho & M. Kutzer, 15Jul2022, USNA

%% Parse input(s)
theta1 = q4(1);
theta2 = q4(2);
theta3 = q4(3);
theta6 = q4(4);

%% Define unknowns (2-soltions)
theta4a = wrapToPi( -(theta2 + theta3 + (pi/2)) );
theta5a = wrapToPi( -pi/2 );

theta4b = wrapToPi( theta4a + pi );
theta5b = wrapToPi( theta5a + pi );

qa = [theta1; theta2; theta3; theta4a; theta5a; theta6];
qb = [theta1; theta2; theta3; theta4b; theta5b; theta6];

%% Define closest solution
if nargin > 1
    dqa = norm(q6_i - qa);
    dqb = norm(q6_i - qb);
    
    if dqa < dqb
        q6 = qa;
    else
        q6 = qb;
    end
else
    q6 = qa;
end


end

