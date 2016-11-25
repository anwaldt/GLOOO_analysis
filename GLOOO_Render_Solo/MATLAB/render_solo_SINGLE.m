%% render_solo_SINGLE.m
%
%
%   This script renders an audio stream
%   from a previously analyzed passage!
%
%
%   HvC
%   Created: 2015-04-10
%   Edited : 2016-11-24
%
%

%% RESET and STARTUP

clearvars
close all
restoredefaultpath

% FILE
baseName    = 'TwoNote_DPA_13';

% STARTUP

render_solo_START;
render_solo_PATHS;
render_solo_PARAM;


%% RUN

y = render_solo_wrapper(baseName, paramSynth,  paths);
