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

function [] = modeling_segments(baseName, paths, setToDo, micToDo)



outName = [paths.segments baseName '.mat'];

if ...%exist(outName,'file') == 0 &&  
    exist([paths.features baseName '.mat'],'file') ~= 0 
    
    
    %% load controll and sinusoid data
    
    % load([paths.sinusoids baseName]);
    load([paths.features baseName]);
    
    param = CTL.param;
    
    if param.info == true
        disp(['    modeling_segments(): Starting with: ' baseName]);
    end
    
    %% load properties of sequence
    % this could be needed, is not yet used.
    
    switch setToDo
        
        case 'TwoNote'
            
            INF = load_solo_properties(regexprep(baseName,'BuK','DPA') , paths, setToDo, micToDo);
            segBounds = load([paths.segSV regexprep(baseName,'BuK','DPA') '.txt']);
            
        case 'SingleSounds'

            try
                INF = load_tone_properties(regexprep(baseName,'BuK','DPA') , paths, setToDo, micToDo);
            catch
                'xxx'    
            end
            
            f1 = fopen([paths.segSV regexprep(baseName,'BuK','DPA') '.txt']);
            segBounds = textscan(f1,'%f %s' );
            fclose(f1);
            
            segType = [2 1 2 0]';
            
            segBounds = [( segBounds{1}), segType];
            
    end
    
    
    
    %% just get all individual segment boundaries
    
    
    
    
    %% Prepare Segments
    
    %[noteBounds, transBounds, noteTrans]  = analyze_segments(segBounds, param, controlTrajectories);
    
    [SEG]  = prepare_segments(segBounds, INF, param, CTL, setToDo);
    
    
    %%  Analyze Segments
    
    SEG = get_segment_parameters(SEG, CTL, param, paths);
    
    
    %% TODO: Write MIDI File (usable by matrix2midi)
    
    % tMID = create_MIDI_sequence(noteBounds, noteModels ,param);
    
    
    %% SAVE STUFF
    
    SOLO        = struct;    
    SOLO.SEG    = SEG;
    SOLO.param  = param;
        
    if param.saveit == true
        
        save(outName,'SOLO')
        
    end
    
else
    
     
end
