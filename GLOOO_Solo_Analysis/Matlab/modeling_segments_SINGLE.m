%% modelling_segments_SINGLE.m
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
 

 
 
 baseName     =  
 

[SEG, INF, CTL] = modeling_segments(baseName, param, paths);


 