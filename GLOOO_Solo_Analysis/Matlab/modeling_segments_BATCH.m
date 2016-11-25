%% modelling_segments_BATCH.m
%
%   Does the solo analysis for a batch of files.
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
%% RESET 
close all
clearvars
restoredefaultpath

%% Set the outup path for this set

outPath = '../Results/1/';


%% SET

modeling_segments_STARTUP
modeling_segments_PATHS
modeling_segments_PARAM

%% start pool

s = matlabpool('size');

if s == 0 && param.parallel == true
    matlabpool
end

%% get list of files

fileNames = dir(paths.wavPrepared);
fileNames = fileNames(~[fileNames.isdir]);

nFiles   = length(fileNames);

%% LOOP over all files

parfor fileCNT = 1:nFiles
    
    
    [~,baseName,~]    = fileparts(fileNames{fileCNT});
    
    
    % Get gontrol- and   trajectories and features
    [CTL]           = basic_analysis(baseName, paths, param);
    
end  
    
%%

parfor fileCNT = 1:nFiles
    
    [~,baseName,~]    = fileparts(fileNames{fileCNT});
 
    % Get partial trajectories
    [SMS]           = partial_analysis(baseName,  paths);
    
    % transform partial data
    % ...
    
 end   
    
%%

 for fileCNT = 1:nFiles
    
    [~,baseName,~]    = fileparts(fileNames{fileCNT});

    % Analysis
    [SEG, INF]      = modeling_segments(baseName, paths);
    
    
end