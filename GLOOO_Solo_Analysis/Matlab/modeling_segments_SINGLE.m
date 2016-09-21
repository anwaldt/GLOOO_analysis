%% modelling_segments_MAIN.m
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


%% Base Name of wav file

baseName    = 'TwoNote_DPA_19';


%% CALL analysis FUNCTION

[SEG, INF, CTL] = modeling_segments(baseName, param, paths);


%% VISUALIZE Segments?
 
% visualize_segments(baseName, paths, [2], [2]);

