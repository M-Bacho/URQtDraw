function [xx,yy,zz] = defineWritingBox(ur)
% DEFINEWRITINGBOX allows the user to define a writing box using the teach
% pendant.
%
%

%% Prompt the user to find the 4 corners of a piece of paper 


%% Touch each corner
for i = 1:4
    fprintf('Touch corner %d of the paper [ENTER TO CONTINUE].',i);
    pause;
    H_e2o{i} = ur.Pose;
    X_e2o(:,i) = H_e2o{i}(1:3,4);
    fprintf('\n');
end

%% Make output(s)
xx = [min(X_e2o(1,:)),max(X_e2o(1,:))];
yy = [min(X_e2o(2,:)),max(X_e2o(2,:))];
zz = [min(X_e2o(3,:)),max(X_e2o(3,:))];