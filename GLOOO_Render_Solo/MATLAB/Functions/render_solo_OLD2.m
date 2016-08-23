%% function [ y ] = render_solo( freqTrack, vibTrack, SM, expMod, paramSynth )
%
%   - generates a solo based on
%
%
% HvC
% Created:  2016-02-18
% Modified: 2016-08-04
%
%

function [ y ] = render_solo(C, notes, trans, SM, expMod, paths, paramSynth)


t = (0:(trans(end).stop)*paramSynth.fs-1)/paramSynth.fs;

% a zero padded output stream
y = [zeros(size(t))'; zeros(paramSynth.fs,1)];


L           = length(y);
lWin        = paramSynth.lWin;
lHop        = paramSynth.lHop;
nWin        = floor((L-2*lWin)/lHop);
targetInds  = 1:lWin;
nNotes      = size(notes,2);

SP          = [];
SMSP        = [];

% this array keeps track of processed messages
usedNotes    = zeros(nNotes,1);
% and this one of controllers
% usedCntrls  = zeros(nControls,1);


%% LOOP over all frames

for frameIDX = 1:nWin
    
    % times (in sec.) to be filled in this loop run
    targetTimes = (targetInds-1)/paramSynth.fs;
    
    % indices of onsets which are within this frame
    onsetsInFrame = ...
        intersect(find([notes.start]>=targetTimes(1)),  ...
        find([notes.start]<=targetTimes(end)));
    
    % indices of offsets which are within this frame
    offsetsInFrame = ...
        intersect(find([notes.stop]>=targetTimes(1)),  ...
        find([notes.stop]<=targetTimes(end)));
    
    %% process all onset events within this frame
    
    for onsetIDX = onsetsInFrame
        
        % check whether it has not been used before
        if   usedNotes(onsetIDX)~=1
            
            % get new notes midi params
            recMIDInote = notes(onsetIDX).MIDI.nn;
            recMIDIvel  = notes(onsetIDX).MIDI.vel;
            
            
            
            % pick responding sample
            [tmpName, ~]  = SM.pick_sample(recMIDInote,recMIDIvel);
            
            % create new sampler object with this information
            %sp = single_sample_player(recMIDInote, recMIDIvel, resamp, tmpName, paths,paramSynth);
            %SP = [SP sp];
            
            % if a previous note exists --- and has not been
            % released we prepare everything for the legato mode:
            if ~isempty(SMSP) && ~isempty(find([SMSP.isReleased]==0, 1))
                
                preNotePos  = find([SMSP.isReleased]==0, 1);
                preNote     = SMSP(preNotePos);
                
                % note is released and finished at the same time
                SMSP(preNotePos).isReleased = 1;
                SMSP(preNotePos).isFinished = 1;
                
                % plot(SMSP.A(:,1:SMSP.framePos)')
                
                % if the same note has been played before (and is still
                % in the release phase)
            elseif ~isempty(SMSP) &&   ~isempty(find([SMSP.nn] == recMIDInote, 1))
                
                preNotePos  = find([SMSP.nn] == recMIDInote, 1);
                preNote     = SMSP(preNotePos);
                
                % note is released and finished at the same time
                SMSP(preNotePos).isReleased = 1;
                SMSP(preNotePos).isFinished = 1;
                
                % all other cases need no connection of the notes
            else
                preNote = [];
            end
            
            % create new SMS object with this information
            smsp = single_sinmod_player(notes(onsetIDX), SM, preNote, expMod, tmpName,paths, paramSynth);
            
            SMSP = [SMSP smsp];
            
            % in case of a 'pure'  offset
            % mark processed message as used
            usedNotes(onsetIDX,:) = 1;
        end
        
    end
    
    %% process all offsets in this frame
    
    for offsetIDX = offsetsInFrame
        
        recMIDInote = notes(offsetIDX).MIDI.nn;
        
        % find note which will be released in ARRAY
        [~, tmpPos] = find([SMSP.nn]==recMIDInote);
        
        if ~isempty(tmpPos)
            %SP(tmpPos).isReleased   = 1;
            
            try
                SMSP(tmpPos).isReleased = 1;
            catch
                'xxx'
            end
            
            % @TODO: figure out how to communicate this between
            %        expression model and sample player
            % SMSP(tmpPos).set_released('detached') = 1;
            
            % set note to fade out
        end
        
    end
    
    
    %% render all active  notes
    
    for noteIDX = 1:length(SMSP)
        
        % process the expressive controls of the active note
        % (the one NOT released)
        if SMSP(noteIDX).isReleased == 0
            
            % somehow this function won't work
            %             SMSP(noteIDX).process_controls(pitchBend(cntrlsInFrame,:));
            
            % so we do it the dirty way
            %             if ~isempty(cntrlsInFrame)
            %                 SMSP(noteIDX).vibCent = mean( pitchBend(cntrlsInFrame,2) );
            %             else
            %                 %                 SMSP(noteIDX).vibCent = 0;
            %             end
            %             usedCntrls(cntrlsInFrame,:) = 1;
        end
        
        % [SP(noteIDX),tmpFrame]    = SP(noteIDX).get_frame();
        if SMSP(noteIDX).isFinished == 0
            
            switch paramSynth.synthMode
                
                case 'IFFT'
                    
                    [SMSP(noteIDX),tmpFrame2] = SMSP(noteIDX).get_frame_IFFT();
                    
                case 'TD'
                    
                    [SMSP(noteIDX),tmpFrame2] = SMSP(noteIDX).get_frame_FD();
                    
            end
            y(targetInds)             = y(targetInds) + tmpFrame2;
            
        end
    end
    
    % kill finished notes
    if~isempty(SMSP)
        
        [~, finished]   = find([SMSP.isFinished]== 1);
        
        %SP(finished) = [];
        SMSP(finished) = [];
        
    end
    
    % increment indices
    targetInds = targetInds + paramSynth.lHop;
    
end

