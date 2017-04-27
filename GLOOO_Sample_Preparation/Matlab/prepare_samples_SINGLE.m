% prepare_samples_SINGLE.m
%
%
% HVC
% Started :     2016-08-10

%% RESET
% Get parameters, paths and co.


close all
clearvars
restoredefaultpath

prepare_samples_STARTUP
prepare_samples_PATHS
prepare_samples_PARAM


%%


baseName = 'SampLib_BuK_01';


[original, tonal, noise] = prepare_sample(baseName, paths, param);

