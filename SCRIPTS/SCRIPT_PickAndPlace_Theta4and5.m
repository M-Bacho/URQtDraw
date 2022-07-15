%% SCRIPT_PickAndPlace_Theta4and5
%
%   M. Bacho & M. Kutzer, 20220715, USNA
clc

syms theta1 theta2 theta3 theta4 theta5 theta6

q = [theta1; theta2; theta3; theta4; theta5; theta6];

H_e2o_sym = UR_fkin('UR3e',q);

R_e2o_sym = H_e2o_sym(1:3,1:3);

z_e2o_sym = R_e2o_sym(1:3,3);

z_e2o_sym = zeroFPError(z_e2o_sym);