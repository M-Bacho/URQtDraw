function j_sym = JacobianPickAndPlace(in1,in2)
%JACOBIANPICKANDPLACE
%    J_SYM = JACOBIANPICKANDPLACE(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 8.7.
%    12-Jul-2022 13:29:14

%UR3e Pick and Place Jacobian
l2 = in2(2,:);
l3 = in2(3,:);
l4 = in2(4,:);
l5 = in2(5,:);
theta1 = in1(1,:);
theta2 = in1(2,:);
theta3 = in1(3,:);
t2 = cos(theta1);
t3 = cos(theta2);
t4 = sin(theta1);
t5 = theta1+theta2;
t6 = theta2+theta3;
t7 = cos(t6);
t8 = sin(t5);
t9 = sin(t6);
t10 = t5+theta3;
t11 = sin(t10);
t12 = l3.*t7;
t13 = l2.*t8;
t15 = l3.*t4.*t9;
t14 = l3.*t11;
t16 = -t12;
j_sym = reshape([t13+t14+l4.*t2+l5.*t4,-l5.*t2+l4.*t4+t2.*t16-l2.*t2.*t3,0.0,1.0,t13+t14,t15+l2.*t4.*sin(theta2),t16-l2.*t3,0.0,t14,t15,t16,0.0,0.0,0.0,0.0,-1.0],[4,4]);
