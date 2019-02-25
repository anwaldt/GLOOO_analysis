%% plot attack and release
%   

%% RESET

close all  
clearvars
restoredefaultpath


p=genpath('../../../MATLAB/');
addpath(p)


%% LOAD YAML FILE

P =  '/home/anwaldt/WORK/GLOOO/GLOOO_synth/MODEL/yaml_60P/';

nr = '03';

MOD = YAML.read([P 'SampLib_BuK_' nr '.yml']);

%%



plot(MOD.ATT.PARTIALS.P_4.AMP.trajectory)