%% render_solo_SINGLE.m
%
%
%   This script renders an audio stream
%   from a previously anayzed passage!
%
%
%   HvC
%   Created: 2015-04-10
%   Edited : 2016-08-09
%
%

%% RESET and STARTUP

clearvars
close all
restoredefaultpath

% FILE
baseName    = 'TwoNote_DPA_15';

% STARTUP

render_solo_START;
render_solo_PATHS;
render_solo_PARAM;


%% RUN

render_solo_wrapper(baseName, paramSynth, param,  paths);
