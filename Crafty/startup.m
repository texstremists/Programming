% STARTUP  Add all files of the toolbox to the MATLAB search path
% 
% Assumption: this file is in the root directory of your toolbox

% Add all project folders and files to the path
rootDir = cd('.');
addpath(genpath(rootDir));
% If the toolbox is cloned, remove the hidden git files from the search path
rmpath(genpath([rootDir, filesep, '.git']))
% Indicate that the toolbox is ready to be used
fprintf('Your Toolbox initialized.\n'); % change it to the name of your toolbox