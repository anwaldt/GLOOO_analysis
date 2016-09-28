%% modelling_segments_BATCH.m
%
% This project needs the audio files to be segmented
% according to the Note-Rest-Transition model!
%
%
%
% Author : Henrik von Coler
%
% Created: 2014-02-17
% Edited : 2016-08-08
%
%
%% RESET and SET

close all
clearvars
restoredefaultpath

modeling_segments_STARTUP
modeling_segments_PATHS
modeling_segments_PARAM

%%

% matlabpool


%% get list of files

fileNames = dir(paths.wavPrepared);
fileNames = {fileNames(3:end).name};

nFiles   = length(fileNames);

%% LOOP over all files

parfor fileCNT = 1:nFiles
    
[~,baseName,~]    = fileparts(fileNames{fileCNT});


% CALL analysis FUNCTION

[SEG, INF, CTL] = modeling_segments(baseName, param, paths);


end