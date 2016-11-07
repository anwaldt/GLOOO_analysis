%% modelling_segments().m
%
% Function for analyzing a sequence,
%   after control- and partial trajectories
%   have been calculated!
%
% Henrik von Coler
%
% Created : 2016-08-08
%
%%

function [SEG, INF, CTL] = modeling_segments(baseName, paths)


%% load controll and sinusoid data

% load([paths.sinusoids baseName]);
load([paths.features baseName]);

param = SMS.param;

%% load properties of sequence
% this could be needed, is not yet used.

INF = load_solo_properties(regexprep(baseName,'BuK','DPA') , paths);



%% just get all individual segment boundaries

segBounds = load([paths.segSV regexprep(baseName,'BuK','DPA') '.txt']);



%% Prepare Segments

%[noteBounds, transBounds, noteTrans]  = analyze_segments(segBounds, param, controlTrajectories);

[SEG]  = prepare_segments(segBounds, INF, param, CTL);


%%  Analyze Segments

SEG = get_segment_parameters(SEG, CTL, param, paths);

 
%% TODO: Write MIDI File (usable by matrix2midi)

% tMID = create_MIDI_sequence(noteBounds, noteModels ,param);


%% SAVE STUFF

SOLO.SEG = SEG;
SOLO.param = param;


if param.saveit == true
    
    save([paths.segments baseName],'SOLO')
    
end
