%% function [] = render_solo_wrapper(baseName, paramSynth, param, paths)
%
%
%
%
%
%
% Author:  Henrik von Coler
% Created: 2016-08-16

function [y] = render_solo_wrapper(baseName, paramSynth, sampMAT,    paths)




%% load Info on the 'solo'

% Number 	Note1 	Note2 	Semitones 	Direction 	Dynamic 	Articulation 	Vibrato 


INF = load_solo_properties(baseName, paths);


%% load segments
% load([paths.segDir regexprep(baseName,'DPA','BuK')]);
load([paths.segDir baseName]);
 
% % we get 
% load([paths.features baseName]);
% param = CTL.param;

% paramSynth.nPartials    = param.PART.nPartials;


%% here comes the expression model

expMod  = expression_model('original');


%% load SOLO analysis parameters and create control trajectories

%[C] = create_control_trajectories(baseName,paths,expMod);



%% Prepare   Data

% load([paths.NOTES baseName]);
% load([paths.TRANS baseName]);

% noteModels(1).F0.trajectory = smooth(noteModels(1).F0.trajectory,10);
% noteModels(2).F0.trajectory = smooth(noteModels(2).F0.trajectory,10);





%% finally: RENDER IT !

% [y]      = render_solo_OLD(noteModels, transModels, sampMAT, expMod, paths, paramSynth);

[y]      = render_solo([], SOLO, sampMAT, expMod, paths, paramSynth);




%% and EXPORT

if paramSynth.saveit == true
  
    % get matlab version
    v = version;
    % as cell array
    V = strsplit(v,'.');
    
    % use wavread or audioread, depending on version
    if str2double(V{1}) < 9
        
        wavwrite( y, paramSynth.fs,[paths.OUTPUT baseName '_Synth-' paramSynth.f0mode '.wav']);

    else
           
        audiowrite([paths.OUTPUT baseName '_Synth-' paramSynth.sustainMode '.wav'], y, paramSynth.fs);
    end
        
        
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