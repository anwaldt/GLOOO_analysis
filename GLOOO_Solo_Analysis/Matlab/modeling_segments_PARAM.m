%% modelling_segments_PARAM.m
%
%   Sets parameters for
%       
%       - control trajectories and features
%       - 
%
% Author : Henrik von Coler
%
% Created: 2014-02-17
% Edited : 2016-08-08
%


%% BASIC PARAMTERS

param.plotit      = false;
param.saveit      = true;
param.info        = true;
param.parallel    = true;
 

%% GLOABAL analyis parameters

% the hop-size is GLOBAL:
param.lHop          = 2^8;

param.lWinRMS       = 2^11;
param.lWinNoise     = 2^12;
% param.lWinSynth     = 2^12;


%% F0 ANALYSIS

param.F0.f0Mode         = 'swipe';
param.F0.lWinYIN        = 2^13;
param.F0.lWinF0         = 2^13;

param.F0.minStrength    = -Inf;

%% f0 decomposition

param.F0decomp.tresh1       = 0.1;
param.F0decomp.cutHighHZ    = 1;
param.F0decomp.cutLowHZ     = 10;


%% Partial tracking

param.PART.getPhases    = true;
param.PART.info         = true;
param.PART.lWin         = 2^12;
    
% upsampling for the autocorr f0-detection
param.PART.upsampFactor  = 5;

% windowsize of peak picking
param.PART.nFFT          = 2^13;
param.PART.nPartials     = 20;
param.PART.fMin          = 20;
param.PART.fMax          = 4000;

% this is for the precision of the phase estimation
% keep in mind: it takes 'param.nPhaseSteps' coarse
%               and 'param.nPhaseSteps' fine steps
param.PART.nPhaseSteps   = 10;
