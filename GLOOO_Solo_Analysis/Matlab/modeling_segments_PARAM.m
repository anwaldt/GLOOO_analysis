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

[~, param.MACHINE] = system('hostname');

param.plotit      = false;
param.saveit      = true;

% debug information
param.info        = true;


%% GLOABAL analyis parameters

% the hop-size is GLOBAL:
param.lHop          = 2^8;

param.lWinRMS       = 2^11;
param.lWinNoise     = 2^12;
% param.lWinSynth     = 2^12;


%% F0 ANALYSIS
% all f0-trajectories are extracted in the 
% first stage - this just tells which to use
% later in modeling

param.F0.f0Mode         = 'swipe';
% param.F0.f0Mode         = 'eckf';
% param.F0.f0Mode         = 'yin';

param.F0.lWinYIN        = 2^14;
param.F0.lWinF0         = 2^13;

param.F0.minStrength    = -Inf;

%% f0 decomposition

param.F0decomp.tresh1       = 0.1;
param.F0decomp.cutHighHZ    = 1;
param.F0decomp.cutLowHZ     = 10;

%% Interpolation

param.F0.numPoints   = 5; % min 5, max 12

param.AMP.numPoints  = 5; % min 5, max 12

%% Partial tracking

% set true to print frame-wise progress
% - recommended only for single file use
param.PART.info         = true;

% threshold of the swipe pitch strength above which the partials are
% tracked
param.PART.psThresh     = 0.1;

param.PART.getPhases    = true;

param.PART.lWin         = 2^12;
    
% upsampling for the autocorr f0-detection
param.PART.upsampFactor  = 5;

% windowsize of peak picking
param.PART.nFFT          = 2^13;
param.PART.nPartials     = 80;
param.PART.fMin          = 20;
param.PART.fMax          = 4000;

% this is for the precision of the phase estimation
% keep in mind: it takes 'param.nPhaseSteps' coarse
% and 'param.nPhaseSteps' fine steps
param.PART.nPhaseSteps   = 11;


%% MODLEING /  NOISE

% number of ICMFs for each paramter:
param.MARKOV.N_distributions  = 21;
% number of support points in each ICMF:
param.MARKOV.N_icmf = 21;

% cutoff frequency for preprocessing partial 
% trajectories before Markovian modeling
% (heuristic standard: 10 Hz)[0.15 0 1]* distCNT/(N_distributions) + [0.15 1 0]* (1-distCNT/(N_distributions))
param.MARKOV.hpf_cutoff = 10;

% plot the inversion process during statistical modeling?
% DO THIS ONLY IN STEPWISE DEBUGGING !!!
% (or generate millions of plots)

param.MARKOV.plot = 0;

% param.MARKOV.plot = 'f0-dist';
% param.MARKOV.plot = 'amp-decomp';
% param.MARKOV.plot = 'noise-decomp'

% param.MARKOV.plot = 'multiple-distributions';



% plot the trajectory decomposition
% DO THIS ONLY IN STEPWISE DEBUGGING !!!
% (or generate millions of plots)
param.MARKOV.plot_decomp = 0; 

%% Modeling Release

param.TRANS.plot = 1;

%%

param.NOISE.order  = 2;
param.NOISE.ripple = 3;
