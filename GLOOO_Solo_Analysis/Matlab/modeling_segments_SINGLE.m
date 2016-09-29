%% modelling_segments_SINGLE.m
%
% Does the solo analysis for a singel file.
%
% This project needs the audio files to be segmented
% according to the Note-Rest-Transition model!
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


%% define in and output

baseName    = 'TwoNote_DPA_275';
outPath     = '../Results/Single/';


%% SETUP scripts

modeling_segments_STARTUP
modeling_segments_PATHS
modeling_segments_PARAM


%% RUN analysis

% Get gontrol- and   trajectories and features
[CTL]           = basic_analysis(baseName, paths, param);

% Get partial trajectories
[SMS]           = partial_analysis(baseName, paths);

% Analysis
[SEG, INF]      = modeling_segments(baseName, paths);

