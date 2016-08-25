%% function [] = render_solo_wrapper(baseName, paramSynth, param, paths)
%
%
%
%
%
%
% Author:  Henrik von Coler
% Created: 2016-08-16

function [] = render_solo_wrapper(baseName, paramSynth, param, paths)


%% Load Sample Library

sampMAT = sample_matrix(paths, paramSynth);


%% load Info on the 'solo'

% Number 	Note1 	Note2 	Semitones 	Direction 	Dynamic 	Articulation 	Vibrato 


I = load_solo_properties(baseName, paths);


%% load segments
load([paths.segments regexprep(baseName,'DPA','BuK')]);


%% here comes the expression model

expMod  = expression_model('original');


%% load SOLO analysis parameters and create control trajectories

[C] = create_control_trajectories(baseName,paths,expMod);



%% Prepare   Data

% load([paths.NOTES baseName]);
% load([paths.TRANS baseName]);

% noteModels(1).F0.trajectory = smooth(noteModels(1).F0.trajectory,10);
% noteModels(2).F0.trajectory = smooth(noteModels(2).F0.trajectory,10);





%% finally: RENDER IT !

% [y]      = render_solo_OLD(noteModels, transModels, sampMAT, expMod, paths, paramSynth);

[y]      = render_solo(C, SEG, sampMAT, expMod, paths, paramSynth);




%% and EXPORT


if paramSynth.saveit == true
    
    y = 0.9* y/max(abs(y));
    
    wavwrite( y, paramSynth.fs,['../WAV/' baseName '_Synth-' paramSynth.f0mode '.wav']);
end

%% PLOT

if paramSynth.plotit == true
    
    figure
    plot(y);
    
    %     figure
    %     plot(   vibMatrix(:,1),vibMatrix(:,2));
    %     ylim(   [0 127]);
    %     xlabel( 't/sec');
    %     ylabel( 'cc Value');
    
    %     figure
    %     plot(freqTrack(:,1),freqTrack(:,2));
    %     xlabel('t/sec');
    %     ylabel('f/Hz')
    
end